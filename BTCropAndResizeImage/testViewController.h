//
//  testViewController.h
//  CoreImageTest
//
//  Created by phonex on 7/16/14.
//  Copyright (c) 2014 lifetime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *imageSlider;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) UIImage *imageToFilter;
@property (strong, nonatomic) NSData *DataResaultFilter;

- (IBAction)changeSliderValue:(id)sender;
- (IBAction)brightButton:(id)sender;
- (IBAction)sharpenButton:(id)sender;
- (IBAction)contrastButton:(id)sender;
@end
