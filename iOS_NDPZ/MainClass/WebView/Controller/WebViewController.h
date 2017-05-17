//
//  HuodongViewController.h
//  XLMM
//
//  Created by younishijie on 16/2/3.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonWebViewViewController.h"

@interface WebViewController : CommonWebViewViewController

//一般来说webDiction是include 3个属性，type_title web_url activity_id
@property (nonatomic,strong) NSMutableDictionary *webDiction;
@property (nonatomic, strong)NSNumber *activityId;

@property (nonatomic,assign) BOOL isShowNavBar;
@property (nonatomic,assign) BOOL isShowRightShareBtn;

@property (nonatomic, strong) UIView *statusBarView;

@end
