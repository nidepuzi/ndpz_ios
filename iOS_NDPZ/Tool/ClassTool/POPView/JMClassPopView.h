//
//  JMClassPopView.h
//  XLMM
//
//  Created by zhang on 17/4/24.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^choiseBlcok)(NSInteger index);

@interface JMClassPopView : UIView

@property (nonatomic, copy) choiseBlcok block;

@property (nonatomic, copy) NSString *messageTitle;

+ (instancetype)shareManager;

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title DescTitle:(NSString *)descTitle Cancel:(NSString *)cancel Sure:(NSString *)sure;

@end
