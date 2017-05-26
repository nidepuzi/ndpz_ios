//
//  CSInviteViewController.m
//  NDPZ
//
//  Created by zhang on 17/4/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSInviteViewController.h"
#import "CSShareManager.h"
#import "JMRichTextTool.h"
#import "CSInviteRecordsController.h"


@interface CSInviteViewController () {
 
}

@property (nonatomic, strong) JMShareModel *shareModel;
@property (nonatomic, strong) CSSharePopController *sharPopVC;

@end

@implementation CSInviteViewController

#pragma mark 懒加载
- (CSSharePopController *)sharPopVC {
    if (!_sharPopVC) {
        _sharPopVC = [[CSSharePopController alloc] init];
        _sharPopVC.popViewHeight = kAppShareViewHeight;
    }
    return _sharPopVC;
}
- (JMShareModel *)shareModel {
    if (!_shareModel) {
        _shareModel = [[JMShareModel alloc] init];
    }
    return _shareModel;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"邀请好礼" selecotr:@selector(backCkick)];
    
    UIImageView *headerImageView = [UIImageView new];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.userInteractionEnabled = YES;
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
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor buttonTitleColor];
    titleLabel.font = CS_UIFontSize(14.);
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *moneyStr1 = @"100";
    NSString *moneyStr2 = @"200";
    NSString *allString = [NSString stringWithFormat:@"成功帮助好友创业,既得%@元现金 \n 好友立奖%@元购物券哦!",moneyStr1,moneyStr2];
//    titleLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:18.] AllString:allString SubStringArray:@[moneyStr1,moneyStr2]];
    titleLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:24] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allString SubStringArray:@[moneyStr1,moneyStr2]];
    [headerImageView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageView.mas_centerY);
        make.centerX.equalTo(headerImageView.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 20);
    }];
    
    UILabel *titleLabel1 = [UILabel new];
    titleLabel1.textColor = [UIColor buttonEnabledBackgroundColor];
    titleLabel1.font = CS_UIFontSize(11.);
    titleLabel1.numberOfLines = 0;
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.text = @"友情提示:好友立奖活动截至日2017-8-30,赶快帮好友创业吧!";
    [headerImageView addSubview:titleLabel1];
    
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(headerImageView.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 20);
    }];
    
    UIButton *invetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerImageView addSubview:invetButton];
    invetButton.backgroundColor = [UIColor colorWithHex:0xff5000];
    invetButton.layer.cornerRadius = 2.;
    [invetButton addTarget:self action:@selector(inviteClick) forControlEvents:UIControlEventTouchUpInside];
    
    [invetButton setTitle:@"邀请方式二  30天试用掌柜" forState:UIControlStateNormal];
    invetButton.titleLabel.font = CS_UIFontSize(13.);
    [invetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *invetZhengshiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerImageView addSubview:invetZhengshiButton];
    invetZhengshiButton.backgroundColor = [UIColor colorWithHex:0xff5000];
    invetZhengshiButton.layer.cornerRadius = 2.;
    [invetZhengshiButton addTarget:self action:@selector(inviteZhengshiClick) forControlEvents:UIControlEventTouchUpInside];
    
    [invetZhengshiButton setTitle:@"邀请方式一  365天正式掌柜" forState:UIControlStateNormal];
    invetZhengshiButton.titleLabel.font = CS_UIFontSize(13.);
    [invetZhengshiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [invetZhengshiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel1.mas_bottom).offset(25);
        make.width.mas_equalTo(@(SCREENWIDTH - 40));
        make.height.mas_equalTo(@(40));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    [invetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(invetZhengshiButton.mas_bottom).offset(15);
        make.width.mas_equalTo(@(SCREENWIDTH - 40));
        make.height.mas_equalTo(@(40));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
 


}

- (void)loadData:(NSString *)activeID {
    [MBProgressHUD showLoading:@""];
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/activitys/%@/get_share_params", Root_URL, activeID];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            return;
        }
        [self resolveActivityShareParam:responseObject];
        
    } WithFail:^(NSError *error) {
        [MBProgressHUD showMessage:@"分享数据请求失败!"];
    } Progress:^(float progress) {
        
    }];
}
- (void)resolveActivityShareParam:(NSDictionary *)dic {
    self.shareModel.share_type = [dic objectForKey:@"share_type"];
    self.shareModel.share_img = [dic objectForKey:@"share_icon"]; //图片
    self.shareModel.desc = [dic objectForKey:@"active_dec"]; // 文字详情
    self.shareModel.title = [dic objectForKey:@"title"]; //标题
    self.shareModel.share_link = [dic objectForKey:@"share_link"];
    self.sharPopVC.model = self.shareModel;
    
    [MBProgressHUD hideHUD];
    [[CSShareManager manager] showSharepopViewController:self.sharPopVC withRootViewController:self WithBlock:^(BOOL dismiss) {
        
    }];
    
    
}


- (void)inviteClick {
    [MobClick event:@"CSInviteViewController_inviteButtonClick"];
    [self loadData:@"8"];
}
- (void)inviteZhengshiClick {
    [MobClick event:@"CSInviteViewController_inviteButtonClick"];
    [self loadData:@"13"];
}


- (void)inviteHistoryClick:(UIButton *)button {
    CSInviteRecordsController *vc = [[CSInviteRecordsController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)backCkick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end































