//
//  CSTrainingModel.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/9.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSTrainingModel.h"

@implementation CSTrainingModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"trainingID":@"id",
             @"descriptionTitle":@"description"};
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 20;
        CGFloat contentH = [self.descriptionTitle boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.]} context:nil].size.height;
        _cellHeight = contentH + 20;
    }
    return _cellHeight;
}





@end
