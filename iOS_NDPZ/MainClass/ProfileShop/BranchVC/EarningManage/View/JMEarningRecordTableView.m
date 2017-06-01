
//
//  JMEarningRecordTableView.m
//  XLMM
//
//  Created by zhang on 17/4/2.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMEarningRecordTableView.h"
#import "CarryLogModel.h"
#import "JMEarningRecordCell.h"
#import "JMReloadEmptyDataView.h"


@interface JMEarningRecordTableView () <UITableViewDelegate, UITableViewDataSource, CSTableViewPlaceHolderDelegate>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *itemDataArr;
@property (nonatomic, strong) NSMutableArray *itemDataSource;

@property (nonatomic, strong) JMReloadEmptyDataView *reload;

@end

static NSString *const JMEarningRecordCellIdentifier = @"JMEarningRecordCellIdentifier";

@implementation JMEarningRecordTableView

- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您还没有收益哦..." DescTitle:@"暂时还没有收益记录哦~" ButtonTitle:@"" Image:@"data_empty" ReloadBlcok:^{
            
        }];
        _reload = reload;
    }
    return _reload;
}

- (NSMutableArray *)itemDataSource {
    if (!_itemDataSource) {
        _itemDataSource = [NSMutableArray array];
    }
    return _itemDataSource;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[JMEarningRecordCell class] forCellReuseIdentifier:JMEarningRecordCellIdentifier];
        
    }
    return self;
}

- (void)refreshWithData:(id)numberOfRows atIndex:(NSInteger)index {
    self.itemDataSource = numberOfRows[index];
    self.currentIndex = index;
    [self cs_reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMEarningRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:JMEarningRecordCellIdentifier];
    if (!cell) {
        cell = [[JMEarningRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMEarningRecordCellIdentifier];
    }
    CarryLogModel *model = self.itemDataSource[indexPath.row];
    [cell configModel:model Index:self.currentIndex];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


@end





































































