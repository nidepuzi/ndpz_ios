//
//  CSWithdrawRecordingModel.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSWithdrawRecordingModel.h"

@implementation CSWithdrawRecordingModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"recordingID":@"id"};
}






@end



@implementation CSWithdrawRecordingBankCardModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"recordingBankCardID":@"id",
             @"recordingBankCardDefault":@"default"};
}



@end

