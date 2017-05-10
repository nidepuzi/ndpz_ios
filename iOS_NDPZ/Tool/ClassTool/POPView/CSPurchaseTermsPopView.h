//
//  CSPurchaseTermsPopView.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, termsPopViewType) {
    termsPopViewTypePurchase,
    termsPopViewTypeCoupon,
    termsPopViewTypeRegist
};

@interface CSPurchaseTermsPopView : UIView


+ (instancetype)defaultPopView;
@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, assign) termsPopViewType termsPopType;


@end
