//
//  JMPushSaveModel.h
//  XLMM
//
//  Created by zhang on 17/4/12.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "Tool_FMDBModel.h"

@interface JMPushSaveModel : Tool_FMDBModel

@property (nonatomic, strong) NSNumber *pushID;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, copy) NSString *currentTime;


@end
