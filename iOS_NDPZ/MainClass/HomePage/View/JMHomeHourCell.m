//
//  JMHomeHourCell.m
//  XLMM
//
//  Created by zhang on 17/4/16.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMHomeHourCell.h"
#import "JMHomeHourModel.h"

@interface JMHomeHourCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *PriceLabel;
@property (nonatomic, strong) UILabel *profitLabel;
@property (nonatomic, strong) UILabel *skuNumLabel;
@property (nonatomic, strong) UILabel *selNumLabel;

@end

@implementation JMHomeHourCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    self.iconImage.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cartCurrentTapAction:)];
//    [self.iconImage addGestureRecognizer:tap];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    self.iconImage.layer.cornerRadius = 5;
    
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.textColor = [UIColor settingBackgroundColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16.];
    self.titleLabel.numberOfLines = 2;
    
    UILabel *PriceLabel = [UILabel new];
    [self.contentView addSubview:PriceLabel];
    self.PriceLabel = PriceLabel;
    self.PriceLabel.font = [UIFont systemFontOfSize:14.];
    self.PriceLabel.textColor = [UIColor settingBackgroundColor];
    
    UILabel *fengexianL = [UILabel new];
    [self.contentView addSubview:fengexianL];
    fengexianL.textColor = [UIColor dingfanxiangqingColor];
    fengexianL.text = @"/";
    
    UILabel *profitLabel = [UILabel new];
    [self.contentView addSubview:profitLabel];
    self.profitLabel = profitLabel;
    self.profitLabel.font = [UIFont systemFontOfSize:14.];
    self.profitLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *skuNumLabel = [UILabel new];
    [self.contentView addSubview:skuNumLabel];
    self.skuNumLabel = skuNumLabel;
    self.skuNumLabel.font = [UIFont systemFontOfSize:12.];
    self.skuNumLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *selNumLabel = [UILabel new];
    [self.contentView addSubview:selNumLabel];
    self.selNumLabel = selNumLabel;
    self.selNumLabel.font = [UIFont systemFontOfSize:12.];
    self.selNumLabel.textColor = [UIColor dingfanxiangqingColor];
    
    
    UIButton *lookWirter = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:lookWirter];
    [lookWirter setTitle:@"分享素材" forState:UIControlStateNormal];
    [lookWirter setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    lookWirter.titleLabel.font = [UIFont systemFontOfSize:13.];
    [lookWirter setImage:[UIImage imageNamed:@"copyWenan"] forState:UIControlStateNormal];
    lookWirter.layer.masksToBounds = YES;
    lookWirter.layer.borderWidth = 0.5f;
    lookWirter.layer.borderColor = [UIColor lineGrayColor].CGColor;
    lookWirter.tag = 100;
    [self edgeInset:lookWirter Space:2];
    [self.contentView addSubview:lookWirter];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:shareButton];
    [shareButton setTitle:@"单品分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:13.];
    [shareButton setImage:[UIImage imageNamed:@"wenanShare"] forState:UIControlStateNormal];
    shareButton.layer.masksToBounds = YES;
    shareButton.layer.borderWidth = 0.5f;
    shareButton.layer.borderColor = [UIColor lineGrayColor].CGColor;
    shareButton.tag = 101;
    [self edgeInset:shareButton Space:2];
    [self.contentView addSubview:shareButton];
    
    UIButton *jiaodianButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:jiaodianButton];
    [jiaodianButton setTitle:@"店铺分享" forState:UIControlStateNormal];
    [jiaodianButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    jiaodianButton.titleLabel.font = [UIFont systemFontOfSize:13.];
    [jiaodianButton setImage:[UIImage imageNamed:@"fenxiangjiaodian"] forState:UIControlStateNormal];
    jiaodianButton.layer.masksToBounds = YES;
    jiaodianButton.layer.borderWidth = 0.5f;
    jiaodianButton.layer.borderColor = [UIColor lineGrayColor].CGColor;
    jiaodianButton.tag = 102;
    [self edgeInset:jiaodianButton Space:2];
    [self.contentView addSubview:jiaodianButton];
    
    [lookWirter addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [jiaodianButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lineLabel = [UILabel new];
    [self.contentView addSubview:lineLabel];
    lineLabel.backgroundColor = [UIColor countLabelColor];
    
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@(100));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.top.equalTo(weakSelf.contentView).offset(12);
        //        make.width.mas_equalTo(@(SCREENWIDTH - 120));
        make.right.equalTo(weakSelf.contentView).offset(-10);
    }];
    
    [self.PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.selNumLabel.mas_top).offset(-5);
    }];
    [fengexianL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.PriceLabel.mas_centerY).offset(-2);
        make.left.equalTo(weakSelf.PriceLabel.mas_right).offset(2);
    }];
    [self.profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fengexianL.mas_right).offset(2);
//        make.bottom.equalTo(weakSelf.selNumLabel.mas_top).offset(-5);
        make.centerY.equalTo(weakSelf.PriceLabel.mas_centerY);
        
    }];
    
    [self.selNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.skuNumLabel.mas_top).offset(-5);
    }];
    [self.skuNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.bottom.equalTo(weakSelf.iconImage);
    }];
    
    
    [lookWirter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView).offset(-15);
        make.width.mas_equalTo(@(SCREENWIDTH / 3));
        make.height.mas_equalTo(@(40));
    }];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lookWirter.mas_right);
        make.bottom.equalTo(weakSelf.contentView).offset(-15);
        make.width.mas_equalTo(@(SCREENWIDTH / 3));
        make.height.mas_equalTo(@(40));
    }];
    [jiaodianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView).offset(-15);
        make.width.mas_equalTo(@(SCREENWIDTH / 3));
        make.height.mas_equalTo(@(40));
    }];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(SCREENWIDTH, 15));
    }];
    
    
}
- (void)edgeInset:(UIButton *)button Space:(CGFloat)space {
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -space, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -space)];
}


- (void)setModel:(JMHomeHourModel *)model {
    _model = model;
    NSString *picString = model.pic;
    NSMutableString *newImageUrl = [NSMutableString stringWithString:picString];
    if ([picString hasPrefix:@"http:"] || [picString hasPrefix:@"https:"]) {
    }else {
        [newImageUrl insertString:@"http:" atIndex:0];
    }
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"icon_placeholderEmpty"]];
    self.titleLabel.text = model.name;
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [model.price floatValue]];
    NSDictionary *profitDic = model.profit;
    self.profitLabel.text = [NSString stringWithFormat:@"赚:¥%.1f",[profitDic[@"min"] floatValue]];
    
    NSInteger kucunNum = [model.stock integerValue];
    if (kucunNum < 0) {
        kucunNum = 0;
    }
    NSInteger zaishouNum = [model.selling_num integerValue];
    self.selNumLabel.text = [NSString stringWithFormat:@"在售人数%ld",zaishouNum];
    self.skuNumLabel.text = [NSString stringWithFormat:@"库存%ld件 ",kucunNum];
    
}
- (void)buttonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeHourCell:Model:ButtonClick:)]) {
        [_delegate composeHourCell:self Model:self.model ButtonClick:button];
    }
    
}


@end





























