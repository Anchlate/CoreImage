//
//  LViewController.h
//  CoreImage滤镜
//
//  Created by anchlate on 14/11/18.
//  Copyright (c) 2014年 ljt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UISlider *slider1;

@property (weak, nonatomic) IBOutlet UISlider *slider2;

@property (weak, nonatomic) IBOutlet UISlider *slider3;

@property (weak, nonatomic) IBOutlet UISlider *slider4;

- (IBAction)sliderChanged1:(id)sender;

- (IBAction)sliderChanged2:(id)sender;

- (IBAction)sliderChanged3:(id)sender;

- (IBAction)sliderChanged4:(id)sender;

- (IBAction)reset:(id)sender;

- (IBAction)load:(id)sender;

- (IBAction)save:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *iv;

@end
