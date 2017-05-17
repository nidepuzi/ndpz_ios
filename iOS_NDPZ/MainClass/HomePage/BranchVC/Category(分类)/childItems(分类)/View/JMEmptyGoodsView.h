//
//  JMEmptyGoodsView.h
//  XLMM
//
//  Created by zhang on 17/4/22.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^emptyGoodsBlock)(NSInteger index);

@interface JMEmptyGoodsView : UIView

@property (nonatomic, copy) emptyGoodsBlock block;


@end
