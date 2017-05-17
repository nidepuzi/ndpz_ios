//
//  JMEditAddressModel.m
//  XLMM
//
//  Created by zhang on 17/5/26.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMEditAddressModel.h"

@implementation JMEditAddressModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"referal_trade_id":@"id",
             @"userAddressDefault":@"default"};
}


@end
