//
//  JMShareViewController.h
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSUInteger, shareVCType) {
//    shareVCTypeInvite,                  // 邀请分享
//    shareVCTypeGoods,                   // 商品分享
//};

@class JMShareModel;
typedef void(^shareCancelBlock)(UIButton *button);

@interface JMShareViewController : UIViewController

//@property (nonatomic, assign) shareVCType shareType;
@property (nonatomic,strong) JMShareModel *model;
@property (nonatomic, copy) shareCancelBlock blcok;


@end
