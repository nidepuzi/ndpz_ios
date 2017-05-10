//
//  CSPopDescriptionController.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/9.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, popDescriptionType) {
    popDescriptionTypeCoupon,
    popDescriptionTypePurchase,
    popDescriptionTypeRegist
};

@interface CSPopDescriptionController : UIViewController

@property (nonatomic, assign) popDescriptionType popDescType;

@end
