颜色工具类

--


工具类优点介绍：使用了NSCache缓存处理颜色对象，可以提高颜色对象在app中的重复使用率。
特别适用重复使用颜色对象的app项目。

1、ColorTool

功能1：可复用的颜色工具类，可以将多个颜色如下通过宏定义配置在该工具文件或者是另外自定义的工具文件中配置app项目中重复使用的颜色对象，下面是一个示例：

```objc

// 背景色
#define COLOR_BACKGROUND_        [@"191919" colorFromRGBHexCode]

// 红色
#define COLOR_RED_               [@"a62424" colorFromRGBHexCode]

// 选中的颜色
#define COLOR_SELECTED_          [@"3e3e3e" colorFromRGBHexCode]

// 绿色
#define COLOR_GREEN_             [@"198a88" colorFromRGBHexCode]

```

功能2：可以通过十六进制字符串获取颜色对象

功能3：查询

下面是对功能2和功能3作用进行统一的使用示例：

```objc
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

```

运行结果：

![](http://img.hoop8.com/attachments/1601/332989414268.png)

展示结果：

![](http://img.hoop8.com/attachments/1601/367989414268.png)



 
