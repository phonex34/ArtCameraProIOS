//
//  testViewController.m
//  CoreImageTest
//
//  Created by phonex on 7/16/14.
//  Copyright (c) 2014 lifetime. All rights reserved.
//

#import "testViewController.h"
#import "UIImage+FiltrrCompositions.h"
#import "cropViewController.h"

#define SCREEN_WIDTH 120
#define SCREEN_HEIGHT 72

@interface testViewController ()

@end

@implementation testViewController
CIContext *context;
CIImage *beginImage;
int tempButton;
int tempFilter=0;

NSMutableDictionary *allFilter;
CIFilter *lighten,*sharpen,*contrast;
UIImageOrientation orientation; // New!

//CIImage* imageFilter ;
NSArray *imageFilter;
NSDictionary *dict;
NSArray *titleFilter;
UIButton *btnTwo;
@synthesize imageSlider;
@synthesize imageView;
@synthesize myScrollView;
@synthesize imageToFilter;
@synthesize DataResaultFilter;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create a orginal imageView
	// Do any additional setup after loading the view, typically from a nib.
//    NSString *filePath =
//    [[NSBundle mainBundle] pathForResource:@"Fnatic" ofType:@"png"];
//    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    //    beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
//    context = [CIContext contextWithOptions:nil];
    
    //filter2 = [CIFilter filterWithName:@"CISepiaTone"
        //                keysAndValues:kCIInputImageKey, beginImage, @"inputIntensity",
      //        @0.0, nil];
  //  CIImage *outputImage = [filter2 outputImage];
     // 2
//  CGImageRef cgimg =
//  [context createCGImage:outputImage fromRect:[outputImage extent]];
//
//    UIImage *newImage = [UIImage imageNamed:@"Fnatic.png"];
  //  UIImage *newImage = imageToFilter;
//  newImage = [newImage e10];
//    newImage = [newImage e5];
//    anImageViewController.image = img;

    // 3
    // UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    imageSlider.hidden=YES;

        self.imageView.image = imageToFilter;
    DataResaultFilter = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        beginImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
        context = [CIContext contextWithOptions:nil];
    // 4
    // CGImageRelease(cgimg);
    
    //create matrix filter
    NSArray *filterName = @[@"Brightness", @"Sharpenss",
                        @"Contrast"];
    NSArray *filterValue = @[[NSNumber numberWithFloat:0.0],
                             [NSNumber numberWithFloat:0.0],
                             [NSNumber numberWithFloat:1.0]];
    allFilter = [NSMutableDictionary dictionaryWithObjects:filterValue forKeys:filterName];



    //create all filter
    lighten = [CIFilter filterWithName:@"CIColorControls"];
    sharpen=   [CIFilter filterWithName:@"CISharpenLuminance"];
    contrast = [CIFilter filterWithName:@"CIColorControls"];
    
    
    //create a scrollview
    imageFilter = [NSArray arrayWithObjects:@"e1.png",@"e2.png",@"e3.png",@"e4.png",@"e5.png", nil];
    titleFilter =[NSArray arrayWithObjects:@"Effect1",@"Effect2",@"Effect3",@"Effect4",@"Effect5", nil];
    
    int leftMargin = 0;
    for (int i = 0; i < [imageFilter count]; i++)
    {
        
        NSLog(@"i la %d",i);
        btnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTwo.frame=CGRectMake(leftMargin, 10, SCREEN_WIDTH-10, SCREEN_HEIGHT-10);
        
        NSString *cacheImage = [NSString stringWithFormat:@"%@",[imageFilter objectAtIndex:i]];
        
        UIImage *niceImage = [UIImage imageNamed:cacheImage];
        btnTwo.tag=i+2;
        [btnTwo setBackgroundImage:niceImage forState:UIControlStateNormal];
        [myScrollView addSubview:btnTwo];
        
        
        //        UIImage *btnImage = [UIImage imageNamed:@"image.png"];
        //        [btnTwo setImage:btnImage forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin-2, 82, 120, 28)
                          ];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[titleFilter objectAtIndex:i]];
        label.tag = i+3;
//        temp=label.tag;
//        NSLog(@"tag la %d",temp);
        [label setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [label setTextColor:[UIColor whiteColor]];
        [myScrollView addSubview:label];
        leftMargin += SCREEN_WIDTH;
        [btnTwo addTarget:self action:@selector(effectSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
        CGSize contentSize = CGSizeMake(leftMargin, SCREEN_HEIGHT+28);
        [self.myScrollView setContentSize: contentSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CIImage *)brightFilter:(CIImage *)img withAmount:(float)intensity {
 
    [allFilter setObject: [NSNumber numberWithFloat:intensity] forKey:@"Brightness"];
       NSLog(@"%@",allFilter);
    [lighten setValue:img forKey:kCIInputImageKey];
    [lighten setValue:[allFilter objectForKey:@"Brightness"] forKey:@"inputBrightness"];
    [sharpen setValue:lighten.outputImage forKey:kCIInputImageKey];
    [sharpen setValue:[allFilter objectForKey:@"Sharpenss"] forKey:@"inputSharpness"];
    [contrast setValue:sharpen.outputImage forKey:kCIInputImageKey];
    [contrast setValue:[allFilter objectForKey:@"Contrast"] forKey:@"inputContrast"];
//    CImageRelease(imageFilter);
    return contrast.outputImage; //7
}

-(CIImage *)sharpenFilter:(CIImage *)img withAmount:(float)intensity {
    
   
    [allFilter setObject: [NSNumber numberWithFloat:intensity] forKey:@"Sharpenss"];
    NSLog(@"%@",allFilter);
    [lighten setValue:img forKey:kCIInputImageKey];
    [lighten setValue:[allFilter objectForKey:@"Brightness"] forKey:@"inputBrightness"];
    [sharpen setValue:lighten.outputImage forKey:kCIInputImageKey];
    [sharpen setValue:[allFilter objectForKey:@"Sharpenss"] forKey:@"inputSharpness"];
    [contrast setValue:sharpen.outputImage forKey:kCIInputImageKey];
    [contrast setValue:[allFilter objectForKey:@"Contrast"] forKey:@"inputContrast"];
    //    CImageRelease(imageFilter);
    return contrast.outputImage; //7
}

-(CIImage *)contrastFilter:(CIImage *)img withAmount:(float)intensity {
    
    [allFilter setObject: [NSNumber numberWithFloat:intensity] forKey:@"Contrast"];
    NSLog(@"%@",allFilter);
    [lighten setValue:img forKey:kCIInputImageKey];
    [lighten setValue:[allFilter objectForKey:@"Brightness"] forKey:@"inputBrightness"];
    [sharpen setValue:lighten.outputImage forKey:kCIInputImageKey];
    [sharpen setValue:[allFilter objectForKey:@"Sharpenss"] forKey:@"inputSharpness"];
    [contrast setValue:sharpen.outputImage forKey:kCIInputImageKey];
    [contrast setValue:[allFilter objectForKey:@"Contrast"] forKey:@"inputContrast"];
    //    CImageRelease(imageFilter);
    return contrast.outputImage; //7
}

- (void) effectSelected:(id)sender{
    //  int bTag = label.tag;
       int btTag=[sender tag];
    UIImage *tempImage=imageView.image;

    switch (btTag) {
        case 2:
            tempImage=[tempImage e1];
            imageView.image=tempImage;
            //
            break;
        case 3:
            tempImage=[tempImage e2];
            imageView.image=tempImage;
            break;
        default:
            break;
    }
 
    NSLog(@"nut %d ",btTag);
}

- (IBAction)changeSliderValue:(id)sender {
//    imageSlider.minimumValue=-0.5;
//    imageSlider.maximumValue=0.5;
    CIImage *outputImage;
//    beginImage =[CIimage ima]
    float slideValue = imageSlider.value;
      NSLog(@"đã vào %f",slideValue);
//    UIImage *tempImage=imageView.image;
//beginImage=imageView.image.CIImage;
  //  context = [CIContext contextWithOptions:nil];
    switch (tempButton) {
        case 1:
            NSLog(@"đã vào bright button %d",tempButton);

                outputImage= [self brightFilter:beginImage withAmount:slideValue];
            
            break;
        case 2:

                outputImage= [self sharpenFilter:beginImage withAmount:slideValue];
            break;
        case 3:
            
                outputImage= [self contrastFilter:beginImage withAmount:slideValue];
            

            break;
        default:
            break;
    }
//    CIImage *outputImage = [self brightFilter:beginImage withAmount:slideValue];
    
    CGImageRef cgimg = [context createCGImage:outputImage
                                     fromRect:[outputImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:orientation];
    self.imageView.image = newImage;
    //
    CGImageRelease(cgimg);
}

- (IBAction)brightButton:(id)sender {
    tempButton=1;
    imageSlider.value=0.0;
    imageSlider.maximumValue=0.5;
    imageSlider.minimumValue=-0.5;
      imageSlider.hidden=NO;
    
}

- (IBAction)sharpenButton:(id)sender {
    tempButton=2;
    imageSlider.value=0.0;
    imageSlider.maximumValue=1;
    imageSlider.minimumValue=-1;
      imageSlider.hidden=NO;
}

- (IBAction)contrastButton:(id)sender {
    tempButton=3;
    imageSlider.value=1.0;
    imageSlider.maximumValue=0.0;
    imageSlider.maximumValue=2.0;
    imageSlider.hidden=NO;
}
- (IBAction)DefaultClicked:(id)sender {
    self.imageView.image=imageToFilter;
    //
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"backToCropped"]) {
        cropViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.imageResaultFilter = [UIImage imageWithData:DataResaultFilter];
        [destinationViewController ResaultFilter];
    }
}
- (IBAction)backClicked:(id)sender {
       DataResaultFilter = UIImageJPEGRepresentation(self.imageView.image, 1.0);
    NSString *string = [[NSString alloc] initWithFormat:@"Ket qua tra ve %d",DataResaultFilter.length];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}



@end
