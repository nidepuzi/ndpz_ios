//
//  CSPopViewAnimationSlide.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+CSPopAnimationViewController.h"

typedef NS_ENUM(NSUInteger, CSPopViewAnimationSlideType) {
    CSPopViewAnimationSlideTypeBottomTop,
    CSPopViewAnimationSlideTypeBottomBottom,
    CSPopViewAnimationSlideTypeTopTop,
    CSPopViewAnimationSlideTypeTopBottom,
    CSPopViewAnimationSlideTypeLeftLeft,
    CSPopViewAnimationSlideTypeLeftRight,
    CSPopViewAnimationSlideTypeRightLeft,
    CSPopViewAnimationSlideTypeRightRight,
};

@interface CSPopViewAnimationSlide : NSObject <CSPopAnimation>

@property (nonatomic, assign) CSPopViewAnimationSlideType type;


@end
