//
//  ViewController.m
//  ColorStringTool
//
//  Created by HEYANG on 16/1/23.
//  Copyright © 2016年 HEYANG. All rights reserved.
//

#import "ViewController.h"
#import "ColorTools.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIView *colorView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    //通过ColorTools内部的webColor的key获取颜色值，并会放入缓存中
    self.colorView.layer.borderColor = [UIColor colorWithHexString:@"black"].CGColor;
    self.colorView.layer.borderWidth = 2.0f;
    self.colorView.layer.cornerRadius = 4.0f;
    
    //通过UIColor的类方法获取UIColor对象
    NSString* colorStr = @"0xff0fff";
    UIColor* color = [UIColor colorWithHexString:colorStr];
    self.colorView.backgroundColor = color;
    
    //通过@"0xff0fff"本身获取UIColor对象
    UIColor* color2 = [@"#ae2388ff" getColorFromColorhexa];
    self.colorView2.backgroundColor = color2;
    
    //宏定义的debug模式的打印两个颜色对象，看看是不是具体实例
    LogColor(color)
    LogColor(color2)
}

@end



