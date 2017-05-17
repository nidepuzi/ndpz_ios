//
//  CSInviteRecordsController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/15.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSInviteRecordsController.h"

@interface CSInviteRecordsController ()

@end

@implementation CSInviteRecordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"邀请记录" selecotr:@selector(backClick)];
    
    
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
