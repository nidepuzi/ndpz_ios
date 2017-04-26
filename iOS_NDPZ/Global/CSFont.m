//
//  CSFont.m
//  NDPZ
//
//  Created by zhang on 17/4/20.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSFont.h"

#define DeviceiPhone6plusWidth 375

@implementation CSFont

- (UIFont *)fontWithSize:(CGFloat)fontSize {
    if (SCREENWIDTH > DeviceiPhone6plusWidth) {
        return [super fontWithSize:fontSize + 2];
    }else {
        return [super fontWithSize:fontSize];
    }
}

+ (UIFont *)resetSystemFontOfSize:(float)fontSize {
    return [super systemFontOfSize:fontSize];
}

+ (UIFont *)resetBoldSystemFontOfSize:(float)fontSize {
    return [super boldSystemFontOfSize:fontSize];
}

+ (UIFont *)heitiLightWithSize:(float)fontSize {
    return [super fontWithName:@"STHeitiSC-Light" size:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [super fontWithName:@"STHeitiSC-Light" size:fontSize];
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [super boldSystemFontOfSize:fontSize];
}

+ (UIFont *)hCFontOfSize:(float)fontSize {
    return [CSFont systemFontOfSize:fontSize];
}

+ (UIFont *)boldHCFontOfSize:(float)fontSize {
    return [CSFont boldSystemFontOfSize:fontSize];
}


@end
