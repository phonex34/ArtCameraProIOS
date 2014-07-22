//
//  ViewController.m
//  BTCropAndResizeImage
//
//  Created by MAC on 7/16/14.
//  Copyright (c) 2014 DanielDuong. All rights reserved.
//

#import "ViewController.h"
#import "resizeImage.h"
#import "cropViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIImage *imageToCrop;
}
@synthesize imageView,boundView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    imageToCrop =[UIImage imageNamed:@"images.jpeg"];
    self.imageView.image = imageToCrop;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Pan gesture recognizer action
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint translation = [recognizer translationInView:self.view];
            
            //allow dragging only in Y coordinates by only updating the Y coordinate with translation position
            recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);
            
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
            
            //get the top edge coordinate for the top left corner of crop frame
            float topEdgePosition = CGRectGetMinY(boundView.frame);
            
            //get the bottom edge coordinate for bottom left corner of crop frame
            float bottomEdgePosition = CGRectGetMaxY(boundView.frame);
            
            //if the top edge coordinate is less than or equal to 53
            if (topEdgePosition <= 0) {
                
                //draw drag view in max top position
                
                boundView.frame = CGRectMake(0, 0, 320, 320);
                
            }
            
            //if bottom edge coordinate is greater than or equal to 480
            
            if (bottomEdgePosition >=426) {
                
                //draw drag view in max bottom position
                boundView.frame = CGRectMake(0, 106, 320, 320);
            }
            
        }
            
        default:
            
            break;
            
            
    }
    
    
}

//truyen du lieu sang view crop image
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cropView"]) {
        NSLog(@"CroppedView was choose");
        cropViewController *destViewController = segue.destinationViewController;
        destViewController.lkBoundView = self.boundView;
        destViewController.lkImageToCrop= self.imageView.image;
    }
}



//open PhotoLabrary to choose Image
-(IBAction)selectImage{
    ImagePicker = [[UIImagePickerController alloc]init];
    ImagePicker.delegate = self;
    UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"Choose Your Image to Crop" message:@"Do you want to go to Camera or PhotoLibrary" delegate:self cancelButtonTitle:@"CAMERA" otherButtonTitles:@"PhotoLibrary", nil];
    message.tag = 1234;
    [message show];
    
    //[ImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
   
   // [ImagePicker release];
}

//Message to choose image
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1234) {
        if (buttonIndex == 0) {
             @try{
            NSLog(@"You choose Camera");
            ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;            
            [self presentViewController:ImagePicker animated:YES completion:NULL];
             }
            @catch(NSException *ex)
            {
                NSString *string = [[NSString alloc]initWithFormat:@"Có lẽ là không có thiết bị Camera có sẵn đi kèm\n %@",ex];
                UIAlertView *message =[[UIAlertView alloc]initWithTitle:@"Message Camera Choice" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [message show];
//                NSLog(@"Error %@ \nCó lẽ là không có thiết bị Camera đi kèm",ex);
            }
        }
        if (buttonIndex == 1) {
            NSLog(@"You choose go to PhotoLibarary");
           
                ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:ImagePicker animated:YES completion:NULL];
            
        }
    }
}

//receiver image return
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *imageChoose = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:imageChoose];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
//click cancel
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
