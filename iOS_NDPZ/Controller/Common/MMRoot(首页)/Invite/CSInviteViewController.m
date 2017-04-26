//
//  CSInviteViewController.m
//  NDPZ
//
//  Created by zhang on 17/4/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSInviteViewController.h"

@interface CSInviteViewController ()

@end

@implementation CSInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"邀请好礼" selecotr:@selector(backCkick)];
    
    UIImageView *headerImageView = [UIImageView new];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:headerImageView];
    UIImage *packsImage = CS_UIImageName(@"invitePacksImage");
    headerImageView.image = packsImage;
    
    CGFloat imageW = SCREENWIDTH;
    CGFloat imageH = packsImage.size.height / packsImage.size.width * imageW;
    
    kWeakSelf
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(@(imageW));
        make.height.mas_equalTo(@(imageH));
    }];
    
    NSString *titleStr = @"邀请好礼";
    CGFloat titleStrW = [titleStr widthWithHeight:20 andFont:13.].width;
    UIButton *invetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:invetButton];
    invetButton.backgroundColor = [UIColor colorWithHex:0xff5000];
    invetButton.layer.cornerRadius = 2.;
    [invetButton setImage:CS_UIImageName(@"pushInImage") forState:UIControlStateNormal];
    [invetButton setImage:CS_UIImageName(@"pushInImage") forState:UIControlStateHighlighted];
    
    [invetButton setTitle:titleStr forState:UIControlStateNormal];
    invetButton.titleLabel.font = CS_UIFontSize(13.);
    [invetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    invetButton.imageEdgeInsets = UIEdgeInsetsMake(0, titleStrW, 0, -titleStrW);
    invetButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    
    [invetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageView.mas_bottom).offset(40);
        make.width.mas_equalTo(@(SCREENWIDTH - 40));
        make.height.mas_equalTo(@(40));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    



}
- (void)backCkick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end































