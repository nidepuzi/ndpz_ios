//
//  JMShareViewController.m
//  XLMM
//
//  Created by 崔人帅 on 16/5/29.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMShareViewController.h"
#import "JMSelecterButton.h"
#import "JMShareButtonView.h"
#import "JMShareModel.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "UUID.h"
#import "SSKeychain.h"
#import "SendMessageToWeibo.h"
#import "JMRichTextTool.h"
#import "JMPopViewAnimationSpring.h"
#import "JMPopViewAnimationDrop.h"
#import "CSPopAnimationViewController.h"
#import "CSHomePageSharePopView.h"

@interface JMShareViewController ()<JMShareButtonViewDelegate>

@property (nonatomic,strong) UIButton *canelButton;
@property (nonatomic,strong) JMShareButtonView *shareButton;
@property (nonatomic, strong) UILabel *earningLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic,strong) UIView *shareBackView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong)NSDictionary *nativeShare;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) CSHomePageSharePopView *popView;


@end

@implementation JMShareViewController {
    BOOL _isPic;
    NSString *_imageUrlString;
    NSString *_content;
    NSString *_urlResource;
    NSString *_titleStr;
    NSString *_url;
    NSString *_kuaizhaoLink;
    UIImage *_imageData;
    UIImage *_kuaiZhaoImage;
    BOOL _isWeixin;
    BOOL _isWeixinFriends;
    BOOL _isCopy;
    
    NSString *_titleUrlString;
    
}
//- (UIView *)maskView {
//    if (!_maskView) {
//        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//        blurEffectView.frame = _maskView.bounds;
//        [_maskView addSubview:blurEffectView];
//        
//        UIButton *saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_maskView addSubview:saveImageBtn];
////        saveImageBtn.backgroundColor = [UIColor orangeColor];
//        [saveImageBtn setTitle:@"保存图片到相册" forState:UIControlStateNormal];
//        [saveImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        saveImageBtn.titleLabel.font = CS_UIFontSize(14.);
//        [saveImageBtn sizeToFit];
//
//        [saveImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_maskView).offset(-40);
//            make.centerX.equalTo(_maskView.mas_centerX);
////            make.width.mas_equalTo(@80);
//            make.height.mas_equalTo(@40);
//        }];
//        [saveImageBtn addTarget:self action:@selector(saveImageClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _maskView;
//}
//- (UIView *)classPopView {
//    if (!_classPopView) {
//        _classPopView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        _classPopView.layer.cornerRadius = 10.f;
////        _classPopView.layer.masksToBounds = YES;
//        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.1, SCREENHEIGHT * 0.1, SCREENWIDTH * 0.8, SCREENHEIGHT * 0.7)];
//        imageV.image = [UIImage imageNamed:@"iPhone4S"];
////        imageV.userInteractionEnabled = YES;
//        imageV.contentMode = UIViewContentModeScaleAspectFill;
//        imageV.layer.cornerRadius = 10.f;
//        imageV.clipsToBounds = YES;
//        imageV.layer.masksToBounds = YES;
//        [_classPopView addSubview:imageV];
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_classPopView addSubview:button];
//        [button setTitle:@"X" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        button.titleLabel.font = CS_UIFontSize(12.);
//        button.backgroundColor = [UIColor redColor];
//        button.layer.cornerRadius = 10;
//        button.layer.masksToBounds = YES;
//        button.frame = CGRectMake(SCREENWIDTH * 0.9 - 10, SCREENHEIGHT * 0.1 - 10, 20, 20);
////        button.cs_x = _classPopView.cs_max_X - 10;
////        button.cs_y = _classPopView.cs_y + 10;
////        button.cs_size = CGSizeMake(40, 40);
//        [button addTarget:self action:@selector(canclePopView) forControlEvents:UIControlEventTouchUpInside];
//        [button  bringSubviewToFront:_classPopView];
        
//    }
//    return _classPopView;
//}
- (CSHomePageSharePopView *)popView {
    if (_popView == nil) {
        _popView = [CSHomePageSharePopView defaultPopView];
        _popView.parentVC = self;
    }
    return _popView;
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, 230);
    [self createShareButtom];
    
    
}


- (void)createShareButtom {
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
//    headerView.layer.masksToBounds = YES;
//    headerView.layer.borderColor = [UIColor lineGrayColor].CGColor;
//    headerView.layer.borderWidth = 1.0f;
    
    [self.view addSubview:headerView];
    self.headerView = headerView;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(100);
    }];
    UILabel *valueLabel = [UILabel new];
    valueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    valueLabel.font = [UIFont systemFontOfSize:24.f];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:valueLabel];
    self.valueLabel = valueLabel;
    
    UILabel *earningLabel = [UILabel new];
    earningLabel.numberOfLines = 0;
    earningLabel.textColor = [UIColor buttonTitleColor];
    earningLabel.font = [UIFont systemFontOfSize:12.f];
    earningLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:earningLabel];
    self.earningLabel = earningLabel;
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(headerView).offset(20);
        make.width.mas_equalTo(SCREENWIDTH - 60);
    }];
    
    [self.earningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(valueLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(SCREENWIDTH - 60);
    }];
    
    
    if (self.shareType == shareVCTypeGoods) {
        self.shareButton.buttonType = shareButtonType1;
        JMShareButtonView *shareButton = [[JMShareButtonView alloc] initWithFrame:CGRectZero shareType:shareButtonType1];
        self.shareButton = shareButton;
    }else {
        self.shareButton.buttonType = shareButtonType2;
        JMShareButtonView *shareButton = [[JMShareButtonView alloc] initWithFrame:CGRectZero shareType:shareButtonType2];
        self.shareButton = shareButton;
    }
//    if (self.shareType == shareVCTypeGoods) {
//        self.shareButton.buttonType = shareButtonType1;
//    }else {
//        self.shareButton.buttonType = shareButtonType2;
//    }
    self.shareButton.delegate = self;
    self.shareButton.layer.cornerRadius = 20;
    [self.view addSubview:self.shareButton];
    self.shareButton.backgroundColor = [[UIColor shareViewBackgroundColor]colorWithAlphaComponent:1.0];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    self.canelButton = cancelButton;
//    [self.canelButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"取消" TitleFont:15. CornerRadius:20];
//    self.canelButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [cancelButton setImage:[UIImage imageNamed:@"share_deleateImage"] forState:UIControlStateNormal];
    [self.canelButton addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.canelButton];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(100);
    }];
    
    [self.canelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareButton.mas_bottom).offset(10);
        make.centerX.equalTo(self.shareButton.mas_centerX);
//        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.width.height.mas_equalTo(40);
    }];
    
    [self upDataWithModeProfit:self.model.profit];

}
- (void)upDataWithModeProfit:(NSDictionary *)profitDic {
    if (profitDic != nil) {
        if (!self.headerView) {
            return ;
        }
        [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(100);
        }];
        NSString *minValue = [NSString stringWithFormat:@"%.2f",[profitDic[@"min"] floatValue]];
        NSString *allStr = [NSString stringWithFormat:@"只要你的好友通过你的链接购买此商品,你就能得到至少%@元的利润哦~",minValue];
        self.headerView.hidden = NO;
        self.valueLabel.text = [NSString stringWithFormat:@"赚 ¥%.2f ~ ¥%.2f",[profitDic[@"min"] floatValue],[profitDic[@"max"] floatValue]];
        self.earningLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:13.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allStr SubStringArray:@[minValue]];
    }else {
        if (!self.headerView) {
            return ;
        }
        [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
        self.headerView.hidden = YES;
    }
}
- (void)setModel:(JMShareModel *)model {
    _model = model;
    [self upDataWithModeProfit:model.profit];
    [self createData];
}
- (void)createData {
    if(_model == nil) return;
    BOOL tpyeB = ([_model.share_type isEqual:@"link"] || [_model.share_type isEqual:@"0"]);
    if (tpyeB) {
        _isPic = NO;
    }else {
        _isPic = YES;
    }
    
    _titleStr = _model.title;
    _content = _model.desc;
    _imageUrlString = _model.share_img;
    _url = _model.share_link;
//    _kuaizhaoLink = _url;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _imageData = [UIImage imagewithURLString:_imageUrlString];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (!_imageData) {
                _imageData = [UIImage imageNamed:@"icon-xiaolu.png"];
            }
        });
    });
    _titleUrlString = [NSString stringWithFormat:@"%@",_content];
}
- (void)setShareType:(shareVCType)shareType {
    _shareType = shareType;
    
}
- (void)composeShareBtn:(JMShareButtonView *)shareBtn didClickBtn:(NSInteger)index {
    NSLog(@"composeShareBtn Index=%ld", index);
    if (index == 10) {
        //微信分享
        if ([NSString isStringEmpty:_url]) {
            [self createPrompt];
            return ;
        }
        if (_isPic) {
            _isWeixin = YES;
            [self cancelBtnClick:nil];
        }else {
            [UMSocialData defaultData].extConfig.wechatSessionData.title = _titleStr;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
            [UMSocialData defaultData].extConfig.wxMessageType = 0;
//            UMSocialUrlResource * urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeImage) url:_imageUrlString];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:_titleUrlString image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//                [self hiddenNavigationView];
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功");
                }
            }];

        }
        [self cancelBtnClick:nil];
    }
//    else if (index == 101) {
//        if ([NSString isStringEmpty:_url]) {
//            [self createPrompt];
//            return;
//        }
//        if (_isPic) {
//            //图片
//            _isWeixinFriends = YES;
//            //        [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
////            [self createKuaiZhaoImage];
//            //        [self createKuaiZhaoImage];
//            [self cancelBtnClick:nil];
//        }else {
//            [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
//            [UMSocialData defaultData].extConfig.wechatTimelineData.title = _titleUrlString;
//            [UMSocialData defaultData].extConfig.wxMessageType = 0;
//            
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_content image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            }];
//            [self cancelBtnClick:nil];
//        }
//    }
    else if (index == 11) {
        if (self.shareType == shareVCTypeGoods) {
            _isCopy = YES;
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            if ([NSString isStringEmpty:_url]) {
                [MBProgressHUD showMessage:@"复制失败"];
            }else {
                [pab setString:_url];
                if (pab == nil) {
                    [MBProgressHUD showMessage:@"请重新复制"];
                }else
                {
                    [MBProgressHUD showMessage:@"已复制"];
                }
            }
            //    [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
            [self cancelBtnClick:nil];
        }else {
            if ([NSString isStringEmpty:_url]) {
                [self createPrompt];
                return;
            }
            [UMSocialData defaultData].extConfig.qqData.url = _url;
            [UMSocialData defaultData].extConfig.qqData.title = _titleStr;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_titleUrlString image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            }];
            
            [self cancelBtnClick:nil];
        }
        
    }
//    else if (index == 103) {
//        if ([NSString isStringEmpty:_url]) {
//            [self createPrompt];
//            return;
//        }
//        [UMSocialData defaultData].extConfig.qzoneData.url = _url;
//        [UMSocialData defaultData].extConfig.qzoneData.title = _titleStr;
//        
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:_titleUrlString image:_imageData location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
////            [self hiddenNavigationView];
//        }];
//        [self cancelBtnClick:nil];
//
//    }
    else if (index == 12) {
        if (self.shareType == shareVCTypeGoods) {
            [self cancelBtnClick:nil];
            
            
            [self showClassPopVoew];
        }else {
            if ([NSString isStringEmpty:_url]) {
                [self createPrompt];
                return;
            }
            NSString *sina_content = [NSString stringWithFormat:@"%@%@",_content, _url];
            [SendMessageToWeibo sendMessageWithText:sina_content andPicture:UIImagePNGRepresentation(_imageData)];
            [self cancelBtnClick:nil];

        }
        
        
        

    }
//    else if (index == 105) {
//        _isCopy = YES;
//        UIPasteboard *pab = [UIPasteboard generalPasteboard];
//        if ([NSString isStringEmpty:_url]) {
//            [MBProgressHUD showMessage:@"复制失败"];
//        }else {
//            [pab setString:_url];
//            if (pab == nil) {
//                [MBProgressHUD showMessage:@"请重新复制"];
//            }else
//            {
//                [MBProgressHUD showMessage:@"已复制"];
//            }
//        }
//        //    [self createKuaiZhaoImagewithlink:self.kuaizhaoLink];
//        [self cancelBtnClick:nil];

//    }
    else { // 6
        NSLog(@"分享按钮被点击了 ===== index == 6");

    }
}

- (void)cancelBtnClick:(UIButton *)button {
    NSLog(@"cancelBtnClick");
    if (self.blcok) {
        self.blcok(button);
    }
    [JMShareView hide];
    [JMPopView hide];

}
- (void)showClassPopVoew {
//    [JMKeyWindow addSubview:self.maskView];
//    [JMKeyWindow addSubview:self.classPopView];
//    [JMPopViewAnimationSpring showView:self.classPopView overlayView:self.maskView];
    [self cs_presentPopView:self.popView animation:[CSPopViewAnimationSpring new] backgroundClickable:NO];
}
//- (void)hideClassPopView {
//    [JMPopViewAnimationSpring dismissView:self.classPopView overlayView:self.maskView];
//}
//-(void)canclePopView {
//    [self hideClassPopView];
//    [self cs_dismissPopViewWithAnimation:[CSPopViewAnimationSpring new]];
//}
//- (void)saveImageClick { // 保存图片
//    UIImage *viewImage = [self createViewImage:self.popView];
//    UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
//}
//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    
//    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
//}
//- (UIImage *)createViewImage:(UIView *)shareView {
//    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
//    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}


//提示分享失败
- (void)createPrompt {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"分享数据获取不全，可能网络不稳定，请重新分享" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end







































