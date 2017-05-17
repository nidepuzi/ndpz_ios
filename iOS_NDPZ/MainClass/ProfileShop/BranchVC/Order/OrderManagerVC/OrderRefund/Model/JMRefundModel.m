//
//  JMRefundModel.m
//  XLMM
//
//  Created by zhang on 17/4/8.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMRefundModel.h"
#import "JMRefundStatusModel.h"

@implementation JMRefundModel

//+ (NSDictionary *)mj_objectClassInArray {
//    return @{@"status_shaft":[JMRefundStatusModel class]};
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"refundID":@"id"};
}


@end
