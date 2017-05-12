//
//  CSAddressManagerCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSAddressManagerCell.h"
#import "JMAddressModel.h"

@interface CSAddressManagerCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *idCardLabel;

@property (nonatomic, strong) UIButton *defaultButton;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *deleateButton;



@end

@implementation CSAddressManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor countLabelColor];
        [self createUI];
    }
    return self;
}
- (void)createUI {
    UIView *zhanshiView = [UIView new];
    [self.contentView addSubview:zhanshiView];
    zhanshiView.backgroundColor = [UIColor whiteColor];
    
    UIView *shezhiView = [UIView new];
    [self.contentView addSubview:shezhiView];
    shezhiView.backgroundColor = [UIColor whiteColor];
    
    kWeakSelf
    [zhanshiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@(120));
    }];
    [shezhiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contentView);
        make.top.equalTo(zhanshiView.mas_bottom).offset(1);
        make.height.mas_equalTo(@(50));
    }];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = [UIColor buttonTitleColor];
    nameLabel.font = CS_UIFontSize(16.);
    nameLabel.numberOfLines = 1;
    [zhanshiView addSubview:nameLabel];
    
    UILabel *phoneLabel = [UILabel new];
    phoneLabel.textColor = [UIColor buttonTitleColor];
    phoneLabel.font = CS_UIFontSize(16.);
    phoneLabel.numberOfLines = 1;
    [zhanshiView addSubview:phoneLabel];
    
    UILabel *addressLabel = [UILabel new];
    addressLabel.textColor = [UIColor dingfanxiangqingColor];
    addressLabel.font = CS_UIFontSize(14.);
    addressLabel.numberOfLines = 2;
    [zhanshiView addSubview:addressLabel];
    
    UILabel *idCardLabel = [UILabel new];
    idCardLabel.textColor = [UIColor dingfanxiangqingColor];
    idCardLabel.font = CS_UIFontSize(14.);
    idCardLabel.numberOfLines = 1;
    [zhanshiView addSubview:idCardLabel];
    
    UIButton *defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shezhiView addSubview:defaultButton];
    [defaultButton setImage:[UIImage imageNamed:@"cs_yuanquanduihao_nomal"] forState:UIControlStateNormal];
    [defaultButton setImage:[UIImage imageNamed:@"cs_yuanquanduihao_selected"] forState:UIControlStateSelected];
    [defaultButton setTitle:@"设为默认" forState:UIControlStateNormal];
    [defaultButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    defaultButton.titleLabel.font = CS_UIFontSize(14.);
    defaultButton.selected = NO;
    defaultButton.tag = 100;
    defaultButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    defaultButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shezhiView addSubview:editButton];
    [editButton setImage:[UIImage imageNamed:@"cs_edit"] forState:UIControlStateNormal];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    editButton.titleLabel.font = CS_UIFontSize(14.);
    editButton.tag = 101;
    defaultButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2);
    defaultButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    
    UIButton *deleateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shezhiView addSubview:deleateButton];
    [deleateButton setImage:[UIImage imageNamed:@"cs_deleate"] forState:UIControlStateNormal];
    [deleateButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleateButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    deleateButton.titleLabel.font = CS_UIFontSize(14.);
    deleateButton.tag = 102;
    deleateButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2);
    deleateButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    
    self.nameLabel = nameLabel;
    self.phoneLabel = phoneLabel;
    self.addressLabel = addressLabel;
    self.idCardLabel = idCardLabel;
    self.defaultButton = defaultButton;
    self.editButton = editButton;
    self.deleateButton = deleateButton;
    [defaultButton addTarget:self action:@selector(sehzhiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [editButton addTarget:self action:@selector(sehzhiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleateButton addTarget:self action:@selector(sehzhiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(zhanshiView).offset(10);
    }];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zhanshiView).offset(-10);
        make.centerY.equalTo(nameLabel.mas_centerY);
    }];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhanshiView).offset(10);
        make.right.equalTo(zhanshiView).offset(-10);
        make.centerY.equalTo(zhanshiView.mas_centerY);
    }];
    [idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhanshiView).offset(10);
        make.bottom.equalTo(zhanshiView).offset(-10);
    }];
    
    [defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shezhiView).offset(10);
        make.centerY.equalTo(shezhiView.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(deleateButton.mas_left).offset(-10);
        make.centerY.equalTo(shezhiView.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
    }];
    [deleateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shezhiView);
        make.centerY.equalTo(shezhiView.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
    }];
    
    
    
    
}

- (void)setAddressModel:(JMAddressModel *)addressModel {
    _addressModel = addressModel;
    
    self.nameLabel.text = addressModel.receiver_name;
    self.phoneLabel.text = addressModel.receiver_mobile;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",addressModel.receiver_state,addressModel.receiver_city,addressModel.receiver_district];
    self.idCardLabel.text = [NSString stringWithFormat:@"身份证 : %@",addressModel.identification_no];
    if ([addressModel.defaultValue boolValue] == 1) {
        self.defaultButton.selected = YES;
    }else {
        self.defaultButton.selected = NO;
    }
    
    
    
    
}
- (void)sehzhiButtonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(modifyAddress:Button:)]) {
        [_delegate modifyAddress:self.addressModel Button:button];
    }
}


@end






















































