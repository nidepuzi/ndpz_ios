//
//  CSWithDrawPopView.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/10.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, popTypeStatus) {
    popTypeStatusPay,
    popTypeStatusWithdraw
};

@interface CSWithDrawPopView : UIView

+ (instancetype)defaultWithdrawPopView;
@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, assign) popTypeStatus typeStatus;


@end
