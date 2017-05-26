//
//  CSInviteRecordingCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSInviteRecordingCell.h"
#import "CSFansModel.h"

@interface CSInviteRecordingCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeLabel;


@end

@implementation CSInviteRecordingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH * 0.28, 60)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.cs_max_X, 0, SCREENWIDTH * 0.28, 60)];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label2.cs_max_X, 0, SCREENWIDTH * 0.16, 60)];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(label3.cs_max_X, 0, SCREENWIDTH * 0.28, 60)];
    [self label:label1];
    [self label:label2];
    [self label:label3];
    [self label:label4];
    
    [self.contentView addSubview:label1];
    [self.contentView addSubview:label2];
    [self.contentView addSubview:label3];
    [self.contentView addSubview:label4];
    
    self.phoneLabel = label1;
    self.nameLabel = label2;
    self.statusLabel = label3;
    self.timeLabel = label4;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lineGrayColor];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREENWIDTH);
        make.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(@1);
    }];
    
    
    
}
- (void)label:(UILabel *)label {
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor buttonTitleColor];
    label.font = CS_UIFontSize(12.);
}





- (void)setModel:(CSFansModel *)model {
    _model = model;
    self.nameLabel.text = model.nick;
    self.phoneLabel.text = model.invitee_mobile;
    self.timeLabel.text = [NSString yearDeal:model.charge_time];
    
    if ([model.invitee_status isEqual:@"forzen"]) {
        self.statusLabel.text = @"已冻结";
    }else {
        if ([model.referal_type integerValue] == 15) {
            self.statusLabel.text = @"未支付";
        }else {
            self.statusLabel.text = @"已支付";
        }
        
    }
    
    
    
    
}











@end
















































































































