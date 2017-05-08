//
//  CSInviteViewController.m
//  NDPZ
//
//  Created by zhang on 17/4/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSInviteViewController.h"
#import "JMShareViewController.h"
#include "JMShareModel.h"

@interface CSInviteViewController ()

@property (nonatomic,strong) JMShareViewController *shareView;
@property (nonatomic, strong) JMShareModel *share_model;

@end

@implementation CSInviteViewController

- (JMShareModel*)share_model {
    if (!_share_model) {
        _share_model = [[JMShareModel alloc] init];
    }
    return _share_model;
}
- (JMShareViewController *)shareView {
    if (!_shareView) {
        _shareView = [[JMShareViewController alloc] init];
        _shareView.shareType = shareVCTypeInvite;
    }
    return _shareView;
}

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
    [invetButton addTarget:self action:@selector(inviteClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [self loadData];



}
- (void)loadData {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, @"8"];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            return;
        }
        [self resolveActivityShareParam:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    } Progress:^(float progress) {
        
    }];
}
- (void)resolveActivityShareParam:(NSDictionary *)dic {
    self.share_model.share_type = [dic objectForKey:@"share_type"];
    self.share_model.share_img = [dic objectForKey:@"share_icon"]; //图片
    self.share_model.desc = [dic objectForKey:@"active_dec"]; // 文字详情
    self.share_model.title = [dic objectForKey:@"title"]; //标题
    self.share_model.share_link = [dic objectForKey:@"share_link"];
    self.shareView.model = self.share_model;
}


- (void)inviteClick {
    [[JMGlobal global] showpopBoxType:popViewTypeShare Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, kAppShareViewHeight) ViewController:self.shareView WithBlock:^(UIView *maskView) {
    }];
    self.shareView.blcok = ^(UIButton *button) {
        [MobClick event:@"WebViewController_shareFail_cancel"];
    };
}



- (void)backCkick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end































