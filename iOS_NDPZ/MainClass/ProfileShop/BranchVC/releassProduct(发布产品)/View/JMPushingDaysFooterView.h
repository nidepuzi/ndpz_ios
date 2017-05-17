//
//  JMPushingDaysFooterView.h
//  XLMM
//
//  Created by zhang on 17/4/10.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMSharePicModel;
@protocol JMPushingDaysFooterViewDelegate <NSObject>

- (void)composeWithShareModel:(JMSharePicModel *)model Button:(UIButton *)button;

@end

@interface JMPushingDaysFooterView : UICollectionReusableView

@property (nonatomic, strong) JMSharePicModel *model;
@property (nonatomic, weak) id<JMPushingDaysFooterViewDelegate> delegate;

@end
