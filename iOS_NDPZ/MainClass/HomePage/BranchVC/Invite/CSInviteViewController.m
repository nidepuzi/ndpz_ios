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

NSString *const CSInviteViewControllerLabel1 = @"1、邀请好友购买365元套装商品“成为正式掌柜” ";
NSString *const CSInviteViewControllerLabel2 = @"（1）获得365元正品超值礼包（2）自购或分享获得返佣（5%-25%）（3）推广一个正式掌柜即得100元现金 （4）全国包邮（海外、港澳台除外）";
NSString *const CSInviteViewControllerLabel3 = @"2、通过试用邀请“成为试用掌柜”  ";
NSString *const CSInviteViewControllerLabel4 = @"（1）全国包邮（海外、港澳台除外）（2）1000件全球精选正品，随心购（3）随时升级成为正式掌柜，享受返佣";


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
    
    UIScrollView *contenScrollView = [[UIScrollView alloc] init];
    contenScrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view addSubview:contenScrollView];
    
    UIImageView *headerImageView = [UIImageView new];
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.userInteractionEnabled = YES;
    [contenScrollView addSubview:headerImageView];
    UIImage *packsImage = CS_UIImageName(@"invitePacksImage");
    headerImageView.image = packsImage;
    
    CGFloat imageW = SCREENWIDTH;
    CGFloat imageH = packsImage.size.height / packsImage.size.width * imageW;
    
    headerImageView.frame = CGRectMake(0, 0, imageW, imageH);
    
    UIButton *invetZhengshiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contenScrollView addSubview:invetZhengshiButton];
    invetZhengshiButton.backgroundColor = [UIColor colorWithHex:0xff5000];
    invetZhengshiButton.layer.cornerRadius = 2.;
    [invetZhengshiButton addTarget:self action:@selector(inviteZhengshiClick) forControlEvents:UIControlEventTouchUpInside];
    [invetZhengshiButton setTitle:@"邀请好友成为正式掌柜" forState:UIControlStateNormal];
    invetZhengshiButton.titleLabel.font = CS_UIFontSize(13.);
    [invetZhengshiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *invetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contenScrollView addSubview:invetButton];
    invetButton.backgroundColor = [UIColor colorWithHex:0xff5000];
    invetButton.layer.cornerRadius = 2.;
    [invetButton addTarget:self action:@selector(inviteClick) forControlEvents:UIControlEventTouchUpInside];
    [invetButton setTitle:@"邀请好友成为试用掌柜" forState:UIControlStateNormal];
    invetButton.titleLabel.font = CS_UIFontSize(13.);
    [invetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    invetZhengshiButton.frame = CGRectMake(30, SCREENHEIGHT / 2 , SCREENWIDTH - 60, 40);
    invetButton.frame = CGRectMake(30, invetZhengshiButton.cs_max_Y + 15 , SCREENWIDTH - 60, 40);
    
    UILabel *label1 = [UILabel new];
    label1.textColor = [UIColor dingfanxiangqingColor];
    label1.font = CS_UIFontSize(14.);
    label1.text = CSInviteViewControllerLabel1;
    label1.numberOfLines = 0;
    
    UILabel *label2 = [UILabel new];
    label2.textColor = [UIColor dingfanxiangqingColor];
    label2.font = CS_UIFontSize(12.);
    label2.text = CSInviteViewControllerLabel2;
    label2.numberOfLines = 0;
    
    UILabel *label3 = [UILabel new];
    label3.textColor = [UIColor dingfanxiangqingColor];
    label3.font = CS_UIFontSize(14.);
    label3.text = CSInviteViewControllerLabel3;
    label3.numberOfLines = 0;
    
    UILabel *label4 = [UILabel new];
    label4.textColor = [UIColor dingfanxiangqingColor];
    label4.font = CS_UIFontSize(12.);
    label4.text = CSInviteViewControllerLabel4;
    label4.numberOfLines = 0;
    
    [contenScrollView addSubview:label1];
    [contenScrollView addSubview:label2];
    [contenScrollView addSubview:label3];
    [contenScrollView addSubview:label4];
    
    CGFloat label1H = [CSInviteViewControllerLabel1 heightWithWidth:SCREENWIDTH - 30 andFont:14.].height;
    CGFloat label2H = [CSInviteViewControllerLabel2 heightWithWidth:SCREENWIDTH - 45 andFont:12.].height;
    CGFloat label3H = [CSInviteViewControllerLabel3 heightWithWidth:SCREENWIDTH - 30 andFont:14.].height;
    CGFloat label4H = [CSInviteViewControllerLabel4 heightWithWidth:SCREENWIDTH - 45 andFont:12.].height;
    
    label1.frame = CGRectMake(15, invetButton.cs_max_Y + 15, SCREENWIDTH - 30, label1H);
    label2.frame = CGRectMake(30, label1.cs_max_Y + 5, SCREENWIDTH - 45, label2H);
    label3.frame = CGRectMake(15, label2.cs_max_Y + 10, SCREENWIDTH - 30, label3H);
    label4.frame = CGRectMake(30, label3.cs_max_Y + 5, SCREENWIDTH - 45, label4H);
    
    
    
    contenScrollView.contentSize = CGSizeMake(SCREENWIDTH, label4.cs_max_Y + 30);
    
    
    
    
    
 


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































