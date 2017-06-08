//
//  JMSelectionGoodsInfoController.h
//  XLMM
//
//  Created by zhang on 17/4/9.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureButtonBlock)(NSDictionary *dic);

@class JMGoodsInfoPopView;
@protocol JMGoodsInfoPopViewDelegate <NSObject>

- (void)composeGoodsInfoView:(JMGoodsInfoPopView *)popView Button:(UIButton *)button AttrubuteDic:(NSMutableDictionary *)attrubuteDic;

@end

@class JMGoodsAttributeTypeView,JMBuyNumberView;
@interface JMGoodsInfoPopView : UIView

@property (nonatomic, strong) NSMutableArray *goodsInfoArray;


@property (nonatomic, strong) JMGoodsAttributeTypeView *sizeView;
@property (nonatomic, strong) JMGoodsAttributeTypeView *colorView;
@property (nonatomic, strong) JMBuyNumberView *buyNumView;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, copy) sureButtonBlock block;
@property (nonatomic, weak) id<JMGoodsInfoPopViewDelegate>delegate;


- (void)initTypeSizeView:(NSArray *)goodsArray TitleString:(NSString *)titleString;




@end
