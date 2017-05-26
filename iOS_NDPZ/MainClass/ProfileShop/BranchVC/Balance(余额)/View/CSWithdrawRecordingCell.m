//
//  CSWithdrawRecordingCell.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/22.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSWithdrawRecordingCell.h"
#import "CSWithdrawRecordingModel.h"


@interface CSWithdrawRecordingCell ()

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;


@end

@implementation CSWithdrawRecordingCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    self.statusLabel = [UILabel new];
    [self.contentView addSubview:self.statusLabel];
    self.statusLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.statusLabel.font = [UIFont systemFontOfSize:13.];
    
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor dingfanxiangqingColor];
    self.timeLabel.font = [UIFont systemFontOfSize:14.];
 
    self.moneyLabel = [UILabel new];
    [self.contentView addSubview:self.moneyLabel];
    self.moneyLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:16.];
    self.moneyLabel.textAlignment = NSTextAlignmentRight;
    
    kWeakSelf
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(-10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY).offset(10);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.statusLabel.mas_centerY);
    }];
    
    
}


- (void)setRecordingModel:(CSWithdrawRecordingModel *)recordingModel {
    _recordingModel = recordingModel;
    
    if ([recordingModel.state isEqual:@"success"]) {
        self.statusLabel.text = @"提现成功";
    }else if ([recordingModel.state isEqual:@"apply"]) {
        self.statusLabel.text = @"提现申请";
    }else if ([recordingModel.state isEqual:@"pending"]) {
        self.statusLabel.text = @"处理中";
    }else if ([recordingModel.state isEqual:@"fail"]) {
        self.statusLabel.text = @"提现失败";
    }else { }
    
    self.timeLabel.text = [NSString jm_deleteTimeWithT:recordingModel.created];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.1f",[recordingModel.amount floatValue]];
    
//    NSLog(@"%@",recordingModel.bank_card.account_no);
    
    
    
    
    
}












@end































































