//
//  LViewController.m
//  CoreImage滤镜
//
//  Created by anchlate on 14/11/18.
//  Copyright (c) 2014年 ljt. All rights reserved.
//

#import "LViewController.h"

@interface LViewController ()
{
    //
    UIImagePickerController *_imagePicker;
    CIContext *_ctx;
    CIImage *_beginImage;
    UIImage *_resultImage;
    CIFilter *_filter1;
    CIFilter *_filter2;
    CIFilter *_filter3;
    CIFilter *_filter4;
    
}
@end

@implementation LViewController

- (void)loadView
{
    [super loadView];
    
    // 创建UIImagePickerController对象，用于选取照片库的照片
    _imagePicker = [[UIImagePickerController alloc] init];
    
    // 将UIImagePickerController的委托对象设为self
    _imagePicker.delegate = self;
    
    _slider1.minimumValue = 0;
    _slider1.maximumValue = 10;
    _slider2.minimumValue = -4;
    _slider2.maximumValue = 4;
    _slider3.minimumValue = -2 * M_PI;
    _slider3.maximumValue = 2 * M_PI;
    _slider4.minimumValue = 0;
    _slider4.maximumValue = 30;
    
    
    // 调用reset方法来驰石化程序界面
    [self reset:nil];
    // 查看所有过滤器的信息
    [self logAllFilters];
    
    // 创建基于CPU的CIContext对象
    _ctx = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:kCIContextUseSoftwareRenderer]];
    
    // 创建基于GPU的CIContext
    _ctx = [CIContext contextWithOptions:nil];
    
    // 创建基于OpenGL优化的CIContext对象
    EAGLContext *eaglctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _ctx = [CIContext contextWithEAGLContext:eaglctx];
    
    // 根据过滤器名来创建过滤器
    _filter1 = [CIFilter filterWithName:@"CIGaussianBlur"];
    _filter2 = [CIFilter filterWithName:@"CIBumpDistortion"];
    _filter3 = [CIFilter filterWithName:@"CIHueAdjust"];
    _filter4 = [CIFilter filterWithName:@"CIPixellate"];
    
}

#pragma mark 查看系统内建的过滤器
- (void)logAllFilters
{
    NSArray *properties = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"所有内建过滤器:\n%@", properties);
    for (NSString *filterName in properties) {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        // 打印所有过滤器的默认属性
        NSLog(@"---%@---%@", filterName, [fltr attributes]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderChanged1:(id)sender {
    // 重设界面上其他UISlider的初始值
    _slider2.value = 0;
    _slider3.value = 0;
    _slider4.value = 0;
    
    CGFloat slideVale = self.slider1.value;
    // 设置该处理器的原始图片
    [_filter1 setValue:_beginImage forKey:@"inputImage"];
    // 未过滤器设置参数
    [_filter1 setValue:[NSNumber numberWithFloat:slideVale] forKey:@"inputRadius"];
    // 得到过滤器处理后的图片
    CIImage *outImage = [_filter1 outputImage];
    CGImageRef tmp = [_ctx createCGImage:outImage fromRect:[outImage extent]];
    
    // 将处理后的图片转换为UIImage
    _resultImage = [UIImage imageWithCGImage:tmp];
    CGImageRelease(tmp);
    
    // 显示图片
    [self.iv setImage:_resultImage];
    
}

- (IBAction)sliderChanged2:(id)sender {
    _slider1.value = 0;
    _slider3.value = 0;
    _slider4.value = 0;
    
    CGFloat slideValue = _slider2.value;
    
    // 设置过滤器处理的演示图片
    [_filter2 setValue:_beginImage forKey:@"inputImage"];
    
    // 为过滤器设置参数
    [_filter2 setValue:[CIVector vectorWithX:150 Y:100] forKey:@"inputCenter"];
    [_filter2 setValue:[NSNumber numberWithFloat:150] forKey:@"inputRadius"];
    [_filter2 setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputScale"];
    
    // 得到过滤器处理后的图片
    CIImage *outImage = [_filter2 outputImage];
    CGImageRef tmp = [_ctx createCGImage:outImage fromRect:[outImage extent]];
    
    // 将处理后的图片转换为UIImage
    _resultImage = [UIImage imageWithCGImage:tmp];
    CGImageRelease(tmp);
    
    //显示图片
    [self.iv setImage:_resultImage];
}

- (IBAction)sliderChanged3:(id)sender {
    _slider1.value = 0;
    _slider2.value = 0;
    _slider4.value = 0;
    
    CGFloat slideValue = _slider3.value;
    
    // 设置过滤器处理的原始图片
    [_filter3 setValue:_beginImage forKey:@"inputImage"];
    
    // 为过滤器设置参数
    [_filter3 setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputAngle"];
    
    // 得到过滤器处理后的图片
    CIImage *outImage = [_filter3 outputImage];
    CGImageRef tmp = [_ctx createCGImage:outImage fromRect:[outImage extent]];
    
    // 将处理后的图片转换为UIImage
    _resultImage = [UIImage imageWithCGImage:tmp];
    CGImageRelease(tmp);
    
    // 显示图片
    [self.iv setImage:_resultImage];
}

- (IBAction)sliderChanged4:(id)sender {
    _slider1.value = 0;
    _slider2.value = 0;
    _slider3.value = 0;
    
    CGFloat slideValue = _slider4.value;
    
    // 设置过滤器的参数
    [_slider4 setValue:_beginImage forKey:@"inputImage"];
    [_slider4 setValue:[CIVector vectorWithX:150 Y:240] forKey:@"inputCenter"];
    [_filter4 setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputScale"];
    
    // 得到过滤器处理后的图片
    CIImage *outImage = [_filter4 outputImage];
    CGImageRef tmp = [_ctx createCGImage:outImage fromRect:[outImage extent]];
    
    // 将处理后的图片转换为UIImage
    _resultImage = [UIImage imageWithCGImage:tmp];
    CGImageRelease(tmp);
    
    // 显示图片
    [self.iv setImage:_resultImage];
}

- (IBAction)reset:(id)sender {
    _slider1.value = 0;
    _slider2.value = 0;
    _slider3.value = 0;
    _slider4.value = 0;
    
    // 得到原始的图片路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"all-fish" ofType:@"png"];
    
    // 将图片路径转换为图片URL
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    
    // 使用文件路径来创建UIImage，设置页面出事显示的图片
    self.iv.image = [UIImage imageWithContentsOfFile:filePath];
    
    // 使用图片URL创建CIImage
    _beginImage = [CIImage imageWithContentsOfURL:fileUrl];
}

- (IBAction)load:(id)sender {
    
    // 显示照片库
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    
    // 调用函数将结果图片保存到照片库中
    UIImageWriteToSavedPhotosAlbum(_resultImage, nil, nil, nil);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 隐藏照片库并退回原来的界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 获取用户选中的照片
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 根据已有的UIImage创建CIImage
    _beginImage = [CIImage imageWithCGImage:selectedImage.CGImage];
    
    // 显示用户选中的照片
    self.iv.image = selectedImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 隐藏照片库并退回原来的界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
