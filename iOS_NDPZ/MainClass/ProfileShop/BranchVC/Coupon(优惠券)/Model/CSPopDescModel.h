//
//  CSPopDescModel.h
//  iOS_NDPZ
//
//  Created by zhang on 17/5/9.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPopDescModel : NSObject

@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, copy) NSString *rowTitle;
@property (nonatomic, assign) CGFloat sectionHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellHeightP;

+ (NSArray *)getCouponSectionDescData;
+ (NSArray *)getCouponRowDescData;

+ (NSArray *)getRegistSectionDescData;
+ (NSArray *)getRegistRowDescData;

+ (NSArray *)getPurchaseSectionDescData;
+ (NSArray *)getPurchaseRowDescData;


+ (NSArray *)getWithdrawSectionDescData;
+ (NSArray *)getWithdrawRowDescData;

+ (NSArray *)getWithdrawCellData;


@end
