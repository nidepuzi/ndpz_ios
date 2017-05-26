//
//  AccountModel.h
//  XLMM
//
//  Created by apple on 16/2/26.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject
@property (nonatomic, strong)NSNumber *budget_type;
@property (nonatomic, copy)NSString *budget_log_type;
@property (nonatomic, copy)NSString *budget_date;
@property (nonatomic, copy)NSString *get_status_display;
@property (nonatomic, copy) NSString *budget_log_type_display;
@property (nonatomic, strong)NSNumber *budeget_detail_cash;
@property (nonatomic, copy)NSString *desc;
@property (nonatomic, copy)NSString *status;

@property (nonatomic, assign) CGFloat cellHeight;


@end



/**
 *  {
 "budeget_detail_cash" = 100;
 "budget_date" = "2017-05-16";
 "budget_log_type" = award;
 "budget_log_type_display" = "\U5956\U91d1\U6536\U76ca";
 "budget_type" = 0;
 desc = "\U60a8\U901a\U8fc7\U5956\U91d1\U6536\U76ca\U6536\U5165100.0\U5143.\U60a8\U63a8\U8350\U4e86\U638c\U67dc%s";
 "get_status_display" = "\U5f85\U786e\U5b9a";
 modified = "2017-05-16T10:30:29.485692";
 status = 2;
 }
 */

