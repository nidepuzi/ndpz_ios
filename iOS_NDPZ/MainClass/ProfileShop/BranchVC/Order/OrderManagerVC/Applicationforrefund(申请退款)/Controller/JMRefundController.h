//
//  JMRefundController.h
//  XLMM
//
//  Created by zhang on 17/4/15.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMRefundController;
@class JMOrderGoodsModel;
@protocol JMRefundControllerDelegate <NSObject>

- (void)Clickrefund:(JMRefundController *)click OrderGoods:(JMOrderGoodsModel *)goodsModel Refund:(NSDictionary *)refundDic;

- (void)Clickrefund:(JMRefundController *)click ContinuePay:(NSDictionary *)continueDic;

@end

@interface JMRefundController : UIViewController

@property (nonatomic,strong) NSDictionary *refundDic;

@property (nonatomic, strong) NSDictionary *continuePayDic;

@property (nonatomic, strong) JMOrderGoodsModel *ordergoodsModel;

@property (nonatomic,weak) id<JMRefundControllerDelegate>delegate;

@end
