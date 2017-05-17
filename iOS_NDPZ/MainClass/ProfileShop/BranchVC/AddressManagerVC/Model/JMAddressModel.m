//
//  JMAddressModel.m
//  XLMM
//
//  Created by zhang on 17/4/21.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMAddressModel.h"

@implementation JMAddressModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"defaultValue":@"default",
             @"addressID":@"id"};
}


@end
