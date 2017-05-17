//
//  GoodsInfoModel.m
//  XLMM
//
//  Created by zhang on 17/5/26.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "GoodsInfoModel.h"
#import "CartListModel.h"
#import "PayExtrasModel.h"

@implementation GoodsInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cart_list":[CartListModel class],
             @"pay_extras":[PayExtrasModel class]};

}



@end
