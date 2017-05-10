//
//  ViewController.m
//  ImageDemo
//
//  Created by Qianrun on 16/5/30.
//  Copyright © 2016年 Qianrun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *youlingImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
    
}


- (void)test {
    
    /*
     1：第一部分：把UIImage对象转换为需要被核心图形库调用的CGImage对象。同时，得到图形的宽度和高度。
     
     2：第二部分：由于你使用的是32位RGB颜色空间模式，你需要定义一些参数bytesPerPixel（每像素大小）和bitsPerComponent（每个颜色通道大小），然后计算图像bytesPerRow（每行有大）。最后，使用一个数组来存储像素的值。
     
     3：第三部分：创建一个RGB模式的颜色空间CGColorSpace和一个容器CGBitmapContext,将像素指针参数传递到容器中缓存进行存储。在后面的章节中将会进一步研究核图形库。
     
     4：第四部分：把缓存中的图形绘制到显示器上。像素的填充格式是由你在创建context的时候进行指定的。
     
     5：第五部分：清除colorSpace和context.
     
     NOTE:当你绘制图像的时候，设备的GPU会进行解码并将它显示在屏幕。为了访问本地数据，你需要一份像素的复制，就像刚才做的那样。
     
     文／smallLabel（简书作者）
     原文链接：http://www.jianshu.com/p/a707e48e5238
     著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
   
     */
    
    // 1
    CGImageRef inputCGImageRef = [self.youlingImageView.image CGImage];
    
    NSUInteger width = CGImageGetWidth(inputCGImageRef);
    NSUInteger height = CGImageGetHeight(inputCGImageRef);
    
    // 2.
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    
    NSUInteger bytesPercomponent = 8;
    
    UInt32 *pixels;
    
    pixels = calloc(height * width, sizeof(UInt32));
    
    // 3.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bytesPercomponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    // 4.
    CGContextDrawImage(context, CGRectMake(0,  0, width, height), inputCGImageRef);
    
    
    // 5. clearup
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    
    /*
     代码解释：
     
     1：定义了一些简单处理32位像素的宏。为了得到红色通道的值，你需要得到前8位。为了得到其它的颜色通道值，你需要进行位移并取截取。
     
     2：定义一个指向第一个像素的指针，并使用2个for循环来遍历像素。其实也可以使用一个for循环从0遍历到width*height，但是这样写更容易理解图形是二维的。
     
     3：得到当前像素的值赋值给currentPixel并把它的亮度值打印出来。
     
     4：增加currentPixel的值，使它指向下一个像素。如果你对指针的运算比较生疏，记住这个：currentPixel是一个指向UInt32的变量，当你把它加1后，它就会向前移动4字节（32位），然后指向了下一个像素的值。
     
     提示：还有一种非正统的方法就是把currentPiexl声明为一个指向8字节的类型的指针，比如char。这种方法，你每增加1，你将会移动图形的下一个颜色通道。与它进行位移运算，你会得到颜色通道的8位数值。
     
     此时此刻，这个程序只是打印出了原图的像素信息，但并没有进行任何修改！下面将会教你如何进行修改。
     
     文／smallLabel（简书作者）
     原文链接：http://www.jianshu.com/p/a707e48e5238
     著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
     */
    // 1.
    
    #define Mask8(x) ((x)&0xFF)
        
    #define R(x) (Mask8(x))
        
    #define G(x) (Mask8(x >> 8))
        
    #define B(x) (Mask8(x >> 16))
    
    NSLog(@"Brightness of image:");
    
    // 2.
    UInt32 *currentPixel = pixels;
    
    for(NSUInteger j = 0; j < height; j++) {
        
        for(NSUInteger i = 0; i < width; i++) {
            
            // 3.
            
            UInt32 color = *currentPixel;
            
            printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
            
            // 4.
            currentPixel++;
            
        }
        
        printf("\n");
        
    }
}









@end