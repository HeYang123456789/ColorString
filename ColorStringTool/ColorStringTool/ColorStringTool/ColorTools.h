//
//  ColorTools.h
//  NSStringColorTools
//
//  Created by HEYANG on 16/1/23.
//  Copyright © 2016年 HEYANG. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface ColorTools : NSObject

/**
 *  使用该工具类，只要在需要的地方 -> import "Color.h"
 *  然后在该文件中，如下面示例，通过宏定义配置app的颜色color
 *
 *  或者，直接通过NSString对象调用下面的NSString类别对象方法获取UIColor对象
 *       直接通过UIColor调用下面的UIColor类别中的类方法获取UIColor对象
 *      
 *  另外，也可以使用下面的宏定义的debug打印
 *  示例：
 *      LogColor(颜色对象)
 *  就能有打印信息判断颜色对象是否存在
 *
 *  将下面的十六进制颜色值转为颜色对象
 *  十六进制的颜色值格式：#666666 0x666666 #88888888 0x88888888
 *  其他错误的格式将无法获取有效的UIColor对象
 *  是否成功有效转为UIColor对象，可以用LogColor(对象)打印看看结果
 */

// 解释：用了这个老外的类别，可以使得[@"191919" colorFromRGBcode]通过方法能够获得需要的颜色，

#pragma mark - 统一管理app的颜色

// 背景色
#define COLOR_BACKGROUND_        [@"191919" colorFromRGBHexCode]

// 红色
#define COLOR_RED_               [@"a62424" colorFromRGBHexCode]

// 选中的颜色
#define COLOR_SELECTED_          [@"3e3e3e" colorFromRGBHexCode]

// 绿色
#define COLOR_GREEN_             [@"198a88" colorFromRGBHexCode]

// 灰色字体
#define COLOR_GRAY_FONT_         [@"575757" colorFromRGBHexCode]

// 黄色
#define COLOR_YELLOW_            [@"d78716" colorFromRGBHexCode]

// 白色
#define COLOR_WHITE_             [@"ffffff" colorFromRGBHexCode]

// 圆圈灰色
#define COLOR_CIRCLE_            [@"C2C2C2" colorFromRGBHexCode]

//
#define COLOR_PURE_              [@"9000ff" colorFromRGBHexCode]




/*************************************************/
// 宏定义 debug模式 打印 -> 如果不是debug模式，就不打印
#ifdef DEBUG // debug模式下

#define LogColor(...) \
if(__VA_ARGS__) \
NSLog(@"存在%@颜色对象",__VA_ARGS__); \
else \
NSLog(@"不存在%@颜色对象",__VA_ARGS__);

#else   // 非debug模式，也就是发布程序的模式下

#define LogColor(...)

#endif
/*************************************************/



@end


@interface UIColor(Hex)

#pragma mark - 通过十六进制获取UIColor对象
/** 从十六进制0x或#字符串获取颜色 */
+ (UIColor *)colorWithHexString:(NSString *)color;

#pragma mark - Web color
/** 根据颜色名获取web color颜色对象 */
+ (UIColor *)webColorForKey:(NSString *)webColorName;

#pragma mark - 关于颜色的注册
/** 注册颜色(value)和颜色对应的名字(key) */
+ (void)registerColor:(UIColor *)color withKey:(NSString *)key;

/** 注册颜色(value)和颜色对应的名字(key)的字典集合 */
+ (void)registerColors:(NSDictionary *)colors;

/** 清除颜色的名字(key)对应的颜色值(value) */
+ (void)clearRegisteredColorForKey:(NSString *)key;

/** 根据key值的的到已经注册了的UIColor对象 */
+ (UIColor *)registeredColorForKey:(NSString *)key;

@end

@interface NSString(Color)


/** 将正确的GRB颜色名或(6为数字xxxxxx)得到对应颜色 */
- (UIColor *)colorFromRGBHexCode;

/** 将正确的GRBA颜色或(8位数字xxxxxxxx)名得到对应颜色 */
- (UIColor *)colorFromRGBAHexCode;

/** 通过作为十六进制的颜色值self取出颜色对象*/
-(UIColor*)getColorFromColorhexa;

/** 直接将self颜色名作为key返回颜色对象 */
- (UIColor *)getColorFromColorNameString;


@end
