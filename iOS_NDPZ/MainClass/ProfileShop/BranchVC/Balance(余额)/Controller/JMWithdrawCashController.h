//
//  JMWithdrawCashController.h
//  XLMM
//
//  Created by zhang on 17/4/6.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^MoneyBlock)(CGFloat money);

@interface JMWithdrawCashController : UIViewController

@property (nonatomic, strong) NSDictionary *personCenterDict;

@property (nonatomic, assign) CGFloat myBlabce;

//@property (nonatomic,copy) MoneyBlock block;

@property (nonatomic, assign) BOOL isMaMaWithDraw;


@end
