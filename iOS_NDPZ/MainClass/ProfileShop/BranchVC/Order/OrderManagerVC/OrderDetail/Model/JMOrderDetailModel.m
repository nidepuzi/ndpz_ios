//
//  JMOrderDetailModel.m
//  XLMM
//
//  Created by zhang on 17/5/28.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMOrderDetailModel.h"
#import "JMOrderGoodsModel.h"
#import "JMPackAgeModel.h"

@implementation JMOrderDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orders":[JMOrderGoodsModel class],
             @"package_orders":[JMPackAgeModel class]};
}



+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"goodsID":@"id"};
}

@end


@implementation CSOrderDetailAddress

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"userAddressID":@"id",
             @"isDefault":@"default"};
}

@end



@implementation CSOrderDetailExtras

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"channels":[CSOrderDetailChannels class]};
    
}

@end


@implementation CSOrderDetailChannels

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"channelsID":@"id"};
}



@end



