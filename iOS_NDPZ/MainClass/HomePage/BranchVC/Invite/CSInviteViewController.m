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

@interface CSInviteViewController () {
    BOOL isloadSuccess;
}

@property (nonatomic, strong) JMShareModel *shareModel;
@property (nonatomic, strong) STPopupController *popupController;
@property (nonatomic, strong) CSSharePopController *sharPopVC;

@end

@implementation CSInviteViewController

#pragma mark 懒加载
- (CSSharePopController *)sharPopVC {
    if (!_sharPopVC) {
        _sharPopVC = [[CSSharePopController alloc] init];
    }
    return _sharPopVC;
}
- (JMShareModel *)shareModel {
    if (!_shareModel) {
        _shareModel = [[JMShareModel alloc] init];
    }
    return _shareModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"邀请好礼" selecotr:@selector(backCkick)];
    
    isloadSuccess = YES;
    
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
        make.top.equalTo(headerImageView.mas_centerY).offset(30);
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
    
    NSString *titleStr = @"邀请好礼";
    CGFloat titleStrW = [titleStr widthWithHeight:20 andFont:13.].width;
    UIButton *invetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerImageView addSubview:invetButton];
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
        make.top.equalTo(titleLabel1.mas_bottom).offset(40);
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
    
    if (!isloadSuccess) {
        isloadSuccess = YES;
        [MBProgressHUD hideHUD];
        [self inviteClick];
    }
    
    
}


- (void)inviteClick {
    if ([NSString isStringEmpty:self.shareModel.share_link]) {
        isloadSuccess = NO;
        [MBProgressHUD showLoading:@""];
        [self loadData];
    }
    if (isloadSuccess) {
        self.sharPopVC.popViewHeight = kAppShareViewHeight;
        [[CSShareManager manager] showSharepopViewController:self.sharPopVC withRootViewController:self];
    }
    
}



- (void)backCkick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end































