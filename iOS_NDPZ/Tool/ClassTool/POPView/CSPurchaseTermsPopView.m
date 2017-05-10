//
//  CSPurchaseTermsPopView.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/8.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPurchaseTermsPopView.h"
#import "CSPopAnimationViewController.h"
#import "JMRichTextTool.h"

@interface CSPurchaseTermsPopView ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation CSPurchaseTermsPopView

+ (instancetype)defaultPopView {
    return [[CSPurchaseTermsPopView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH * 0.8, (SCREENWIDTH * 0.8) * 1.5)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.f;
        self.layer.masksToBounds = YES;
        
        
        UITextView * textView = [[UITextView alloc] init];
        textView.textColor = [UIColor blackColor];
        textView.font = [UIFont systemFontOfSize:16.f];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.editable = NO;
        textView.selectable = NO;
        textView.layer.cornerRadius = 10.f;
        textView.layer.masksToBounds = YES;
        self.textView = textView;
        
        
        
        [self addSubview:textView];
        
        kWeakSelf
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.width.mas_equalTo(@(SCREENWIDTH * 0.8));
            make.height.mas_equalTo(@(SCREENWIDTH * 1.1));
        }];
        
        UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [quedingBtn setTitle:@"确定" forState:UIControlStateNormal];
        [quedingBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        quedingBtn.titleLabel.font = CS_UIFontSize(16.);
        [quedingBtn addTarget:self action:@selector(quedingClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:quedingBtn];
        
        [quedingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textView.mas_bottom);
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.width.equalTo(textView.mas_width);
            make.height.mas_equalTo(@(SCREENWIDTH * 0.1));
        }];
    }
    return self;
}
- (void)setTermsPopType:(termsPopViewType)termsPopType {
    _termsPopType = termsPopType;
    NSString *allString = [self getStringWithType:termsPopType];
//    self.textView.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont boldSystemFontOfSize:18.] SubColor:[UIColor blackColor] AllString:allString SubStringArray:@[@"购买须知"]];
    self.textView.text = allString;
}

- (void)quedingClick {
    [_parentVC cs_dismissPopViewWithAnimation:[CSPopViewAnimationSpring new]];
}
- (NSString *)getStringWithType:(termsPopViewType)type {
    if (type == termsPopViewTypeCoupon) {
        return @"1.如何查看我的优惠卷？\n 在APP，点击底部导航栏[店铺]中优惠卷进行查询；\n 2.目前平台有哪些种类的优惠卷？\n 目前平台有满减卷，即满一定额度门槛可享受使用优惠卷；目前满减卷的优惠额度是满一百减五十，即使用优惠卷的门槛是100元，单笔订单只可使用一张优惠卷。\n 3.如何判断是否满足优惠卷的使用条件？\n a优惠卷是有有效期的，使用日期需在有效期范围内；\n b订单的商品金额(是指商品金额，不包含运费、税费)必须满足优惠卷的使用门槛。\n 4.优惠卷可以叠加使用吗？\n 一个订单达到使用门槛只可使用一张优惠卷，不可叠加使用。\n 5.使用优惠卷下单后，若申请售后，优惠卷退还给用户吗？\n 使用优惠卷下单购买商品后，申请售后进行退款退货时，优惠卷也会退还给用户帐号上。";
    }else if (type == termsPopViewTypeRegist) {
        return nil;
    }else if (type == termsPopViewTypePurchase) {
        return @"购买须知\n 1.正品保证：\n 您的铺子所有商品均从海内外正规供货商或品牌商直供，货源正品保障。\n 2.全场包邮：\n 你的铺子全场商品支持全国范围内包邮（港澳台除外），暂不支持寄往港澳台和国外。\n 3.关于发货：\n a.国内自营商品：一般24小时发货，发货后3－5天到货，如遇大促销活动及快递爆仓等情况会有所延迟。\n b.国内保税区商品：一般情况下您的订单经审核后交由海关清关，清关完成后由保税区发区，一般需要5-14个工作日左右完成发货，发货后3-10个工作日左右到货，因涉及海关清关、节假日及物流等因素可能会有所延迟。\n c.品牌直发商品：品牌方自营商品，将由品牌方自行安排发货，具体发货事宜可参考商品详情页说明。\n 4.关于快递：\n 你的铺子仓储与多家快递公司合作，保证所有国内地区均有快递可以送达，暂不支持指定的快递。\n 5.关于签收：\n 收到商品后需要您当场验货确认无误后再签收，如果是包装完好且本人签收后再反馈少发、错发等类似问题，请自理。若非当面签收后发现异常请第一时间联系快递核实。\n 6.关于退换货：\n 6.1无理由退货：在产品完好不影响二次销售的情况下，支持收货后7天无理由换货（蔬果生鲜/食品饮料/保健滋补/计生/特卖、抢购/美妆护理/珠宝/饰品/钟表/眼镜，保税区及其他页面特别说\n 明商品不支持无理由退换货），换货寄回运费需买家承担。\n 6.2非无理由退换货：因商品质量问题，破损错发等非买家原因导致的退货（蔬果生鲜/过敏、快递延迟等除外），支持收货后7天内退换货，来回运费由你的铺子承担。\n 7.联系客服：\n 7.1客服电话：    （服务时间9：00-18：00）\n 7.2通过你的铺子服务号：（nidepuzi）或你的铺子APP中客服直接联系在线客服，客服在线时间9：00-18：00，节假日正常工作。(客服不在线时间请留言，客服上线后会第一时间为您处理问题。) ";
    }else {
        return nil;
    }
    
}







@end






























































































