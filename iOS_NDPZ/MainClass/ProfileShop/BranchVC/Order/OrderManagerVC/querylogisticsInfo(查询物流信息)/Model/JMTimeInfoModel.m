//
//  JMTimeInfoModel.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/7.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMTimeInfoModel.h"

@implementation JMTimeInfoModel

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat contentW = SCREENWIDTH - 60;
        CGFloat contentH = [self.content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:CS_UIFontSize(14.)} context:nil].size.height;
        _cellHeight = contentH + 60;
    }
    return _cellHeight;
}



@end
