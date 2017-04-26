//
//  CSFont.h
//  NDPZ
//
//  Created by zhang on 17/4/20.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSFont : UIFont

+ (UIFont *)resetSystemFontOfSize:(float)fontSize;

+ (UIFont *)resetBoldSystemFontOfSize:(float)fontSize;

+ (UIFont *)heitiLightWithSize:(float)fontSize;

+ (UIFont *)hCFontOfSize:(float)fontSize;

+ (UIFont *)boldHCFontOfSize:(float)fontSize;


@end
