//
//  CSNewFeatureCell.h
//  iOS_NDPZ
//
//  Created by zhang on 17/4/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSNewFeatureCellDelegate <NSObject>

- (void)composeNewFeatureStartClick:(UIButton *)button;

@end

@interface CSNewFeatureCell : UICollectionViewCell

@property (nonatomic, weak) id<CSNewFeatureCellDelegate> delegate;
@property (nonatomic,strong) UIImage *image;

//判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count;

@end
