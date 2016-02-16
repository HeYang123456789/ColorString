//
//  ColorTools.m
//  NSStringColorTools
//
//  Created by HEYANG on 16/1/23.
//  Copyright © 2016年 HEYANG. All rights reserved.
//


#import "ColorTools.h"

// hexa decimal color string regex 正则匹配
#define NSString_Color_HEXADECIMAL_COLOR_STRING_REGEX     @"[0-9A-Fa-f]{6,8}"

#pragma mark - Class initialization 全局静态变量
static __strong NSCache             *colorsCache;
static __strong NSMutableDictionary *dicCustomColors;
//这个hexadecimalStringRegex是用来匹配没有"#"开头的6~8位十六进制字母
static __strong NSRegularExpression *hexadecimalStringRegex;

#pragma mark - ColorTools 颜色工具类
@implementation ColorTools

+ (void)load
{
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorsCache            = [[NSCache alloc] init];
        dicCustomColors        = [[NSMutableDictionary alloc] init];
        hexadecimalStringRegex = [NSRegularExpression regularExpressionWithPattern:NSString_Color_HEXADECIMAL_COLOR_STRING_REGEX
                                                                           options:0
                                                                             error:nil];
        
    });
}

@end

#pragma mark - UIColor的类别

@implementation  UIColor(Hex)


#pragma mark 通过十六进制获取UIColor对象
+ (UIColor *)colorWithHexString:(NSString *)colorHexString
{
    //0、将大写的都转为小写的字母
    colorHexString = [colorHexString lowercaseString];
    //1、全转为大写
    colorHexString = [[colorHexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //2、如果缓存中有就应该从缓存中取出，并返回这个颜色对象
    UIColor* color =  [colorsCache objectForKey:colorHexString];
    
    if (color) {
        return color;
    }
    
    /*===============有0x和#就裁去================*/
    
    // strip 0x or # if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([colorHexString hasPrefix:@"0X"])
    {
        NSString* cutString = [colorHexString substringFromIndex:2];
        // 裁去0x
        if ([self hexaDecimalStringRegexMatchString:cutString]) {
            if (cutString.length == 6) {
                return [cutString colorFromRGBHexCode];
            }else if (cutString.length == 8){
                return [cutString colorFromRGBAHexCode];
            }
        }
        
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([colorHexString hasPrefix:@"#"])
    {
        // 裁去#
        NSString* cutString = [colorHexString substringFromIndex:1];
        if ([self hexaDecimalStringRegexMatchString:cutString]) {
            if (cutString.length == 6) {
                return [cutString colorFromRGBHexCode];
            }else if (cutString.length == 8){
                return [cutString colorFromRGBAHexCode];
            }
        }
    }
    
    if ([self hexaDecimalStringRegexMatchString:colorHexString]) {
        /*===============返回RGB或者RGBA================*/
        // RGB Code
        if (colorHexString.length == 6) {
            // 返回对应的RGB的UIColor对象
            return [colorHexString colorFromRGBHexCode];
        }
        // RGBA Code
        if (colorHexString.length == 8) {
            return [colorHexString colorFromRGBAHexCode];
        }
    }
    
    /*====不符合十六进制颜色数位6或8就通过字典中查找=====*/
    return [colorHexString getColorFromColorNameString];
}



#pragma mark Web color
/**
 *  通过web Color名来获取web Color颜色值
 *
 *  color对象名(NSString) -> key = color -> colorDiction[key]
 *
 *  思路：将color对象名大小写小写化 -> 判断缓存区中是否有color对象名(has change and return) ->
 *  懒加载首次创建webColor列表字典 -> 判断这个列表字典是否有color对象名(has change , save and return)
 *
 *  @param aWebColorName -> a Web Color Name
 *
 *  @return -> a web UIColor
 */
+ (UIColor *)webColorForKey:(NSString *)webColorName
{
    // Check cache first, to prevent unusful tests
    NSString *key = [webColorName lowercaseString];
    UIColor *color = [colorsCache objectForKey:key];
    if (color)
        return color;
    
    //=====================================================//
    /*通过一次性函数，创建一次静态区存储webColor的字典对象*/
    //=====================================================//
    static __strong NSDictionary *dicWebColors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dicWebColors =
        @{
          @"darkgreen":            @"006400" ,
          @"antiquewhite":         @"FAEBD7" ,
          @"aqua":                 @"00FFFF" ,
          @"aquamarine":           @"7FFFD4" ,
          @"azure":                @"F0FFFF" ,
          @"beige":                @"F5F5DC" ,
          @"bisque":               @"FFE4C4" ,
          @"black":                @"000000" ,
          @"blanchedalmond":       @"FFEBCD" ,
          @"blue":                 @"0000FF" ,
          @"blueviolet":           @"8A2BE2" ,
          @"brown":                @"A52A2A" ,
          @"burlywood":            @"DEB887" ,
          @"cadetblue":            @"5F9EA0" ,
          @"chartreuse":           @"7FFF00" ,
          @"chocolate":            @"D2691E" ,
          @"coral":                @"FF7F50" ,
          @"cornflowerblue":       @"6495ED" ,
          @"cornsilk":             @"FFF8DC" ,
          @"crimson":              @"DC143C" ,
          @"cyan":                 @"00FFFF" ,
          @"darkblue":             @"00008B" ,
          @"darkcyan":             @"008B8B" ,
          @"darkgoldenrod":        @"B8860B" ,
          @"darkgray":             @"A9A9A9" ,
          @"darkgreen":            @"006400" ,
          @"darkkhaki":            @"BDB76B" ,
          @"darkmagenta":          @"8B008B" ,
          @"darkolivegreen":       @"556B2F" ,
          @"darkorange":           @"FF8C00" ,
          @"darkorchid":           @"9932CC" ,
          @"darkred":              @"8B0000" ,
          @"darksalmon":           @"E9967A" ,
          @"darkseagreen":         @"8FBC8F" ,
          @"darkslateblue":        @"483D8B" ,
          @"darkslategray":        @"2F4F4F" ,
          @"darkturquoise":        @"00CED1" ,
          @"darkviolet":           @"9400D3" ,
          @"deeppink":             @"FF1493" ,
          @"deepskyblue":          @"00BFFF" ,
          @"dimgray":              @"696969" ,
          @"dodgerblue":           @"1E90FF" ,
          @"firebrick":            @"B22222" ,
          @"floralwhite":          @"FFFAF0" ,
          @"forestgreen":          @"228B22" ,
          @"fuchsia":              @"FF00FF" ,
          @"gainsboro":            @"DCDCDC" ,
          @"ghostwhite":           @"F8F8FF" ,
          @"gold":                 @"FFD700" ,
          @"goldenrod":            @"DAA520" ,
          @"gray":                 @"808080" ,
          @"green":                @"008000" ,
          @"greenyellow":          @"ADFF2F" ,
          @"honeydew":             @"F0FFF0" ,
          @"hotpink":              @"FF69B4" ,
          @"indianred":            @"CD5C5C" ,
          @"indigo":               @"4B0082" ,
          @"ivory":                @"FFFFF0" ,
          @"khaki":                @"F0E68C" ,
          @"lavender":             @"E6E6FA" ,
          @"lavenderblush":        @"FFF0F5" ,
          @"lawngreen":            @"7CFC00" ,
          @"lemonchiffon":         @"FFFACD" ,
          @"lightblue":            @"ADD8E6" ,
          @"lightcoral":           @"F08080" ,
          @"lightcyan":            @"E0FFFF" ,
          @"lightgoldenrodyellow": @"FAFAD2" ,
          @"lightgreen":           @"90EE90" ,
          @"lightgrey":            @"D3D3D3" ,
          @"lightpink":            @"FFB6C1" ,
          @"lightsalmon":          @"FFA07A" ,
          @"lightseagreen":        @"20B2AA" ,
          @"lightskyblue":         @"87CEFA" ,
          @"lightslategray":       @"778899" ,
          @"lightsteelblue":       @"B0C4DE" ,
          @"lightyellow":          @"FFFFE0" ,
          @"lime":                 @"00FF00" ,
          @"limegreen":            @"32CD32" ,
          @"linen":                @"FAF0E6" ,
          @"magenta":              @"FF00FF" ,
          @"maroon":               @"800000" ,
          @"mediumaquamarine":     @"66CDAA" ,
          @"mediumblue":           @"0000CD" ,
          @"mediumorchid":         @"BA55D3" ,
          @"mediumpurple":         @"9370DB" ,
          @"mediumseagreen":       @"3CB371" ,
          @"mediumslateblue":      @"7B68EE" ,
          @"mediumspringgreen":    @"00FA9A" ,
          @"mediumturquoise":      @"48D1CC" ,
          @"mediumvioletred":      @"C71585" ,
          @"midnightblue":         @"191970" ,
          @"mintcream":            @"F5FFFA" ,
          @"mistyrose":            @"FFE4E1" ,
          @"moccasin":             @"FFE4B5" ,
          @"navajowhite":          @"FFDEAD" ,
          @"navy":                 @"000080" ,
          @"oldlace":              @"FDF5E6" ,
          @"olive":                @"808000" ,
          @"olivedrab":            @"6B8E23" ,
          @"orange":               @"FFA500" ,
          @"orangered":            @"FF4500" ,
          @"orchid":               @"DA70D6" ,
          @"palegoldenrod":        @"EEE8AA" ,
          @"palegreen":            @"98FB98" ,
          @"paleturquoise":        @"AFEEEE" ,
          @"palevioletred":        @"DB7093" ,
          @"papayawhip":           @"FFEFD5" ,
          @"peachpuff":            @"FFDAB9" ,
          @"peru":                 @"CD853F" ,
          @"pink":                 @"FFC0CB" ,
          @"plum":                 @"DDA0DD" ,
          @"powderblue":           @"B0E0E6" ,
          @"purple":               @"800080" ,
          @"red":                  @"FF0000" ,
          @"rosybrown":            @"BC8F8F" ,
          @"royalblue":            @"4169E1" ,
          @"saddlebrown":          @"8B4513" ,
          @"salmon":               @"FA8072" ,
          @"sandybrown":           @"F4A460" ,
          @"seagreen":             @"2E8B57" ,
          @"seashell":             @"FFF5EE" ,
          @"sienna":               @"A0522D" ,
          @"silver":               @"C0C0C0" ,
          @"skyblue":              @"87CEEB" ,
          @"slateblue":            @"6A5ACD" ,
          @"slategray":            @"708090" ,
          @"snow":                 @"FFFAFA" ,
          @"springgreen":          @"00FF7F" ,
          @"steelblue":            @"4682B4" ,
          @"tan":                  @"D2B48C" ,
          @"teal":                 @"008080" ,
          @"thistle":              @"D8BFD8" ,
          @"tomato":               @"FF6347" ,
          @"turquoise":            @"40E0D0" ,
          @"violet":               @"EE82EE" ,
          @"wheat":                @"F5DEB3" ,
          @"white":                @"FFFFFF" ,
          @"whitesmoke":           @"F5F5F5" ,
          @"yellow":               @"FFFF00" ,
          @"yellowgreen":          @"9ACD32" };
    });
    //=====================================================//
    
    // Try to retrieve webcolor code尝试检索webcolor代码
    NSString *colorCode = [dicWebColors objectForKey:key];
    if (colorCode)
    {
        // Compute color webColor
        // 字典检索的一定是RGB颜色值，不是RGBA
        color = [colorCode colorFromRGBHexCode];
        
        // Hold color
        [colorsCache setObject:color
                        forKey:key];
        
        return color;
    }
    
    return [UIColor clearColor];
}

#pragma mark Custom colors 关于注册颜色和根据key获取颜色
//1、自定义key(自己去个颜色名),自定义UIColor，存储在全局静态字典中，清除缓存中同key的颜色对象
+ (void)registerColor:(UIColor *)color withKey:(NSString *)key
{
    NSString *lcKey = [key lowercaseString];
    
    [dicCustomColors setObject:color
                        forKey:lcKey];
    [colorsCache removeObjectForKey:lcKey];
}
//2、根据key清除自定义UIColor对象（全局静态字典和缓存中都清除）
+ (void)clearRegisteredColorForKey:(NSString *)key
{
    NSString *lcKey = [key lowercaseString];
    
    [dicCustomColors removeObjectForKey:lcKey];
    [colorsCache removeObjectForKey:lcKey];
}
//3、注册存储多个存储key和value的集合字典对象
+ (void)registerColors:(NSDictionary *)colors
{
    NSMutableDictionary *updatedDic = [[NSMutableDictionary alloc] init];
    UIColor *color;
    id value;
    NSString *lowercaseKey;
    for (NSString *key in colors)
    {
        // Compute lowercase key
        lowercaseKey = [key lowercaseString];
        
        value = [colors objectForKey:key];
        if ([value isKindOfClass:[UIColor class]])
        {
            [updatedDic setObject:value
                           forKey:lowercaseKey];
            [colorsCache removeObjectForKey:lowercaseKey];
        }
        else if ([value isKindOfClass:[NSString class]])
        {
            // 如果这个value是字符串类型，比如可能是@"#ff87a89"
            // Try to extract color
            color = [UIColor colorWithHexString:value];
            if (color)
            {
                [updatedDic setObject:color
                               forKey:lowercaseKey];
                [colorsCache removeObjectForKey:lowercaseKey];
            }
        }
    }
    
    // Add custom colors
    [dicCustomColors addEntriesFromDictionary:updatedDic];
}
/** 根据key值的的到已经注册了的UIColor对象 */
+ (UIColor *)registeredColorForKey:(NSString *)key
{
    // Check cache first, to prevent unusful tests
    NSString *lcKey = [key lowercaseString];
    UIColor *color = [colorsCache objectForKey:lcKey];
    if (color)// 如果缓存中有，就直接返回color
        return color;
    
    // Try to retrieve color
    color = [dicCustomColors objectForKey:lcKey];
    if (color)
    {
        // Hold color in cache
        [colorsCache setObject:color
                        forKey:lcKey];
    }
    
    return color;
}
#pragma mark 私有辅助方法 不被外部调用
+(BOOL)hexaDecimalStringRegexMatchString:(NSString*)matchStr{
    NSRange match = [hexadecimalStringRegex rangeOfFirstMatchInString:matchStr options:0 range:NSMakeRange(0, matchStr.length)];
    if (match.location == 0 && match.length == matchStr.length) {
        return YES;
    }else{
        return NO;
    }
}

@end

#pragma mark - NSString的类别


@implementation NSString(Color)
/**
 *  因为是关于颜色名的NSString对象(比如@"#ffffff98")，所以肯定没有类方法
 */

#pragma mark - get RGB and RGBA Color
// 通过self作为颜色名key值取出RGBA颜色对象
- (UIColor *)colorFromRGBHexCode
{
    UIColor *color = [colorsCache objectForKey:self];
    if (color)
        return color;
    
    unsigned int colorRGBhexaCode = 0;
    
    // Scan hex number
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    [scanner scanHexInt:&colorRGBhexaCode];
    
    // Extract color components
    unsigned int redColor   = (colorRGBhexaCode >> 16);
    unsigned int greenColor = (colorRGBhexaCode >>  8) & 0x00FF;
    unsigned int blueColor  =  colorRGBhexaCode        & 0x0000FF;
    
    // Create result color
    color = [UIColor colorWithRed:redColor/255.0 green:greenColor/255.0 blue:blueColor/255.0 alpha:1.0];
    
    // Update cache
    if (color)
    {
        [colorsCache setObject:color
                        forKey:self];
    }
    
    return color;
}
// 通过self作为颜色名key值取出RGB颜色对象
- (UIColor *)colorFromRGBAHexCode
{
    UIColor *color = [colorsCache objectForKey:self];
    if (color)
        return color;
    
    unsigned int colorRGBhexaCode = 0;
    
    // Scan hex number
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    [scanner scanHexInt:&colorRGBhexaCode];
    
    // Extract color components
    unsigned int redColor   = (colorRGBhexaCode >> 24);
    unsigned int greenColor = (colorRGBhexaCode >> 16) & 0x00FF;
    unsigned int blueColor  = (colorRGBhexaCode >>  8) & 0x0000FF;
    unsigned int alphaColor =  colorRGBhexaCode        & 0x000000FF;
    
    // Create result color
    color = [UIColor colorWithRed:redColor/255.0f green:greenColor/255.0f blue:blueColor/255.0f alpha:alphaColor/255.0f];
    
    // Update cache
    if (color)
    {
        [colorsCache setObject:color
                        forKey:self];
    }
    return color;
}

// 通过作为十六进制的颜色值self取出颜色对象
-(UIColor*)getColorFromColorhexa
{
    return [UIColor colorWithHexString:self];
}

// 通过self作为颜色名key值取出颜色对象
- (UIColor *)getColorFromColorNameString
{
    UIColor *color = [colorsCache objectForKey:self];
    if (color)
        return color;
    
    // Check custom colors
    color = [UIColor registeredColorForKey:self];
    if (color)
        return color;

    
    // Check for web color
    color = [UIColor webColorForKey:self];
    if (color)
        return color;
    
    SEL sel = NSSelectorFromString(self);
    if ([UIColor respondsToSelector:sel])
    {
        color = [UIColor performSelector:sel];
    }
    else
    {
        SEL selColor = NSSelectorFromString([self stringByAppendingString:@"Color"]);
        if ([UIColor respondsToSelector:selColor])
            color = [UIColor performSelector:selColor];
    }
    
    // Update cache
    if (color)
    {
        [colorsCache setObject:color
                        forKey:self];
    }
    return color;
}


@end




/*
 末尾优化相关思考：
    关于加载全局静态变量，比如NSCache *colorsCache的变量，我原本打算放在+(void)initialize方法里懒加载
    意思就是：当我需要用这个类的方法的时候，就会调用initialize方法，并懒加载了全局静态变量
    但是，我考虑到这样在性能上当然不如load一开始就加载好然后快速加载调用这个类
    而且，当我需要这个工具类的时候，如果用initalize方法，那还要等待initialize加载好，再调用
    
    另外，更重要的也是更符合我们实际编码的细节，我们既然需要这个工具类，八九不离十一定会用它，既然会用，那就一定需要里面的方法。那么，全局静态变量加载好，晚加载还不如早加载。
    所以，综上所诉，放在+load方法里最合适。
*/