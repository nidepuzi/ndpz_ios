//
//  JMOrderDetailSectionView.h
//  XLMM
//
//  Created by zhang on 17/4/7.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMOrderDetailSectionView,JMPackAgeModel;
@protocol JMOrderDetailSectionViewDelegate <NSObject>

- (void)composeSectionView:(JMOrderDetailSectionView *)sectionView Index:(NSInteger)index;

@end

@interface JMOrderDetailSectionView : UIView

@property (nonatomic,strong) JMPackAgeModel *packageModel;

@property (nonatomic, assign) NSInteger indexSection;


@property (nonatomic, weak) id<JMOrderDetailSectionViewDelegate>delegate;

@end
