//
//  PayExtrasModel.h
//  XLMM
//
//  Created by zhang on 17/5/26.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayExtrasModel : NSObject
/**
 *  支付与优惠方式
 */
@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *pid;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *use_coupon_allowed;

@property (nonatomic,copy) NSString *value;

@end
