//
//  CartListModel.m
//  XLMM
//
//  Created by zhang on 17/5/26.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "CartListModel.h"

@implementation CartListModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"cartID":@"id"};
}


@end
