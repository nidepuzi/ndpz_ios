//
//  JMAllOrderModel.m
//  XLMM
//
//  Created by zhang on 17/4/7.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMAllOrderModel.h"
#import "JMOrderGoodsModel.h"

@implementation JMAllOrderModel


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orders":[JMOrderGoodsModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"goodsID":@"id"};
}

@end



@implementation CSAllorderExtras




@end
