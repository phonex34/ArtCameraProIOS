//
//  cropViewController.h
//  BTCropAndResizeImage
//
//  Created by MAC on 7/17/14.
//  Copyright (c) 2014 DanielDuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface cropViewController : UIViewController<UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>{
    UIImage *imageToResize;
    SLComposeViewController *composeViewController;
}
@property (strong, nonatomic) UIView *lkBoundView;
@property (strong, nonatomic) UIImage *lkImageToCrop;
@property (strong, nonatomic) IBOutlet UIImageView *ImageViewCropped;
@property (strong, nonatomic) IBOutlet UITextField *txtField;
@property (strong, nonatomic) UIImage *imageResaultFilter;

-(void)ResaultFilter;
@end
