//
//  cropViewController.m
//  BTCropAndResizeImage
//
//  Created by MAC on 7/17/14.
//  Copyright (c) 2014 DanielDuong. All rights reserved.
//

#import "cropViewController.h"
#import "resizeImage.h"
#import "testViewController.h"

@interface cropViewController ()

@end

@implementation cropViewController

@synthesize ImageViewCropped,lkBoundView,lkImageToCrop,txtField,imageResaultFilter;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtField.delegate = self;
    [self cropImageMethod];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) cropImageMethod {
    //get top corner coordinate of crop frame
    float topEdgePosition = CGRectGetMinY(lkBoundView.frame);
    //create UIIMage instance to hold cropped result
    UIImage *croppedImage;
    
    //crop image to selected bounds
    CGRect croppedRect;
    CGFloat variableToCrop = (lkImageToCrop.size.height/420);
    croppedRect = CGRectMake(0, variableToCrop*topEdgePosition, 320*variableToCrop, 320*variableToCrop);//0,topEdgePosition,320,320
    CGImageRef tmp = CGImageCreateWithImageInRect([lkImageToCrop CGImage], croppedRect);
    croppedImage = [UIImage imageWithCGImage:tmp];
    CGImageRelease(tmp);
    
    //convert cropped image into NSData object
    NSData *CroppedImageData = UIImageJPEGRepresentation(croppedImage, 1.0);
    NSData *imageData = UIImageJPEGRepresentation(lkImageToCrop, 1.0);
    
    //get number of bytes in NSData
    NSInteger imageToCropDataSize = imageData.length;
    
    NSLog(@"original size %d Bytes", imageToCropDataSize);
    
    imageToResize = [UIImage imageWithData:CroppedImageData];
    [self resizeImage];
}


//resizeImage for storage
- (void) resizeImage {
    
    //call resize image class
    resizeImage *imageResize = [[resizeImage alloc]init];
    [imageResize resizeImage:imageToResize width:320 height:320];
    NSData *resizedImageData = [imageResize thumbnailImageData];
    
    NSInteger resizedImageDataSize = resizedImageData.length;
    
    ImageViewCropped.image = [UIImage imageWithData:resizedImageData];
    NSLog(@"resized size %d Bytes", resizedImageDataSize);
  
    
}


//action for click button share
- (IBAction)onClickButtonShare:(id)sender {
    [self shareClicked];
}



//action for click save image

- (IBAction)onClickSaveImage:(id)sender {
    
    [self savePhoto];
}



//---------------------------------------------------------

//method share image to facebook
- (void)shareClicked
{
    NSString *tempString = [NSString stringWithFormat:@"%@",txtField.text];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [composeViewController addImage:ImageViewCropped.image];
        [composeViewController setInitialText:tempString];
        [self presentViewController:composeViewController animated:YES completion:NULL];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Account Found" message:@"Configure a Facebook Account in setting" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}

//set keboard and return button
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField) {
        [txtField resignFirstResponder];
    }
    return NO;
}

//set location for textField when keyBoard appear
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame =CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y-170), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame =CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y+170), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}




//---------------------------------------------------------------



//save image method
-(void)savePhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:@"Save To Camera Roll"];
    //put cancel button the last one
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex=actionSheet.numberOfButtons -1;
    [actionSheet showInView:[self.view window]];
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
   // if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save To Camera Roll"]) {
    if (buttonIndex == 0){
        //save photo
        UIImage *image = ImageViewCropped.image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedPhotosAlbum:didFinishSavingWithError: contextInfo:), nil);
    }
}
-(void)imageSavedPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message;
    NSString *title;
    if (!error) {
        title = @"";
        message = @"Your Photo was saved to the camera Roll.";
        
    }else{
        title = @"";
        message = [error description];
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


//----------------------------------
//truyen du lieu sang view filter image
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"filterView"]) {
        testViewController *destViewController = segue.destinationViewController;
        destViewController.imageToFilter = ImageViewCropped.image;

    }
}

-(void)ResaultFilter
{
    ImageViewCropped.image = imageResaultFilter;
}


@end










