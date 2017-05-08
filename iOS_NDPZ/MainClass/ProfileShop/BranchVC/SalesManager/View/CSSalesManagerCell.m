//
//  CSSalesManagerCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/4/28.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSSalesManagerCell.h"
#import "CSSalesCellModel.h"

@interface CSSalesManagerCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *activeTimeLabel;


@end

@implementation CSSalesManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.describeLabel];
        [self.contentView addSubview:self.activeTimeLabel];
        
        kWeakSelf
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(15);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(-10);
        }];
        [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView).offset(15);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(10);
        }];
        [self.activeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView).offset(-15);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        }];
        
        
    }
    return self;
}

- (void)setModel:(CSSalesCellModel *)model {
    _model = model;
//    _iconImageView.image = [UIImage imageNamed:@"default.jpg"];
    _nameLabel.text = model.name;
    _describeLabel.text = model.describe;
    _activeTimeLabel.text = model.activeTime;
}

#pragma mark - 懒加载
//- (UIImageView *)iconImageView {
//    if(_iconImageView == nil) {
//        _iconImageView = [[UIImageView alloc] init];
//        _iconImageView.layer.cornerRadius = 24 / 375.0 * SCREENWIDTH;
//        _iconImageView.layer.masksToBounds = YES;
//    }
//    return _iconImageView;
//}

- (UILabel *)nameLabel {
    if(_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor dingfanxiangqingColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)describeLabel {
    if(_describeLabel == nil) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.textColor = [UIColor dingfanxiangqingColor];
        _describeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _describeLabel;
}

- (UILabel *)activeTimeLabel {
    if(_activeTimeLabel == nil) {
        _activeTimeLabel = [[UILabel alloc] init];
        _activeTimeLabel.textColor = [UIColor dingfanxiangqingColor];
        _activeTimeLabel.textAlignment = NSTextAlignmentRight;
        _activeTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _activeTimeLabel;
}

#pragma mark - 设置子视图的frame
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.iconImageView.frame = CGRectMake(10, 6 / 375.0 * SCREENWIDTH, 48 / 375.0 * SCREENWIDTH, 48 / 375.0 * SCREENWIDTH);
//    self.nameLabel.frame = CGRectMake(10 + 56 / 375.0 * SCREENWIDTH, 10 / 375.0 * SCREENWIDTH, 150 / 375.0 * SCREENWIDTH, 20 / 375.0 * SCREENWIDTH);
//    self.describeLabel.frame = CGRectMake(10 + 56 / 375.0 * SCREENWIDTH, 35 / 375.0 * SCREENWIDTH, 210 / 375.0 * SCREENWIDTH, 15 / 375.0 * SCREENWIDTH);
//    self.activeTimeLabel.frame = CGRectMake(SCREENWIDTH - 100 / 375.0 * SCREENWIDTH - 10, 10 / 375.0 * SCREENWIDTH, 100 / 375.0 * SCREENWIDTH, 20 / 375.0 * SCREENWIDTH);
    
//}
@end
























