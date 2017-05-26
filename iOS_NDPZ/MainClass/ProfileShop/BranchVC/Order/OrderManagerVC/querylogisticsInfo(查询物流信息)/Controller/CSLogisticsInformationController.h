//
//  CSLogisticsInformationController.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/23.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMPackAgeModel;
@interface CSLogisticsInformationController : UIViewController

@property (nonatomic, strong) JMPackAgeModel *packageModel;
@property (nonatomic, strong) NSArray *orderDataSource;

@property (nonatomic, copy) NSString *packetID;
@property (nonatomic, copy) NSString *companyCODE;

@end
