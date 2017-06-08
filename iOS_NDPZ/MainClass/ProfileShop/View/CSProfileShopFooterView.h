//
//  CSProfileShopFooterView.h
//  NDPZ
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, profileStatus) {
    profileStatusShiyong,
    profileStatusZhengshi
};

@class CSProfileShopFooterView;
@protocol CSProfileShopFooterViewDelegte <NSObject>

- (void)composeProfileShopFooter:(CSProfileShopFooterView *)headerView ButtonActionClick:(UIButton *)button;

@end

@interface CSProfileShopFooterView : UIView

- (instancetype)initWithFrame:(CGRect)frame Type:(profileStatus)type;

@property (nonatomic, weak) id <CSProfileShopFooterViewDelegte> delegate;
@property (nonatomic, copy) NSString *accountMoney;
@property (nonatomic, assign) profileStatus statusType;

@end
