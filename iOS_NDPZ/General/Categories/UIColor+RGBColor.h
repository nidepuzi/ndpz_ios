//
//  UIColor+RGBColor.h
//  XLMM
//
//  Created by younishijie on 15/8/7.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGBColor)

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIColor *)buttonBorderColor;
+ (UIColor *)orangeThemeColor;
+ (UIColor *)buttonEnabledBackgroundColor;
+ (UIColor *)buttonDisabledBackgroundColor;
+ (UIColor *)buttonEnabledBorderColor;
+ (UIColor *)buttonDisabledBorderColor;
+ (UIColor *)buttonEmptyBorderColor;
+ (UIColor *)settingBackgroundColor;
+ (UIColor *)mamaCenterBorderColor;
+ (UIColor *)textDarkGrayColor;
+ (UIColor *)pothoViewBackgroundColor;
+ (UIColor *)pagecontrolBackgroundColor;
+ (UIColor *)pagecontrolCurrentIndicatorColor;
+ (UIColor *)youhuiquanrequireColor;
+ (UIColor *)shareViewBackgroundColor;
+ (UIColor *)loadingViewBackgroundColor;
+ (UIColor *)backgroundlightGrayColor;
+ (UIColor *)lineGrayColor;
+ (UIColor *)cartViewBackGround;
+ (UIColor *)rootViewButtonColor;
+ (UIColor *)tabBarTitleDarkGrayColor;
+ (UIColor *)countLabelTextColor;
+ (UIColor *)touxiangBorderColor;
+ (UIColor *)youhuiquanValueColor;
+ (UIColor *)dingfanxiangqingColor;
+ (UIColor *)countLabelColor;
+ (UIColor *)buttonTitleColor;
+ (UIColor *)randomColor;
+ (UIColor *)orderYellowColor;
+ (UIColor *)wechatBackColor;
+ (UIColor *)timeLabelColor;
+ (UIColor *)titleDarkGrayColor;
+ (UIColor *)sectionViewColor;
+ (UIColor *)couponValueColor;
//蓝色
+ (UIColor *)colorWithBlueColor;

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHex:(uint)hex;
+ (UIColor *)colorWithHex:(uint)hex alpha:(CGFloat)alpha;


@end
