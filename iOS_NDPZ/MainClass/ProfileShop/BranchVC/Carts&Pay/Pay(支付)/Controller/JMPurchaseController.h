//
//  JMPurchaseController.h
//  XLMM
//
//  Created by zhang on 17/4/21.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMPurchaseController : UIViewController


@property (nonatomic, strong) NSMutableArray *purchaseGoods;
@property (nonatomic, strong) NSNumber * directBuyGoodsTypeNumber;
/**
 *  获取商品购买商品ID
 */
@property (nonatomic ,copy) NSString *paramstring;

@end
