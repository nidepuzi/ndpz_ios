//
//  CSPopDescriptionController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/9.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSPopDescriptionController.h"
#import <STPopup/STPopup.h>
#import "CSPopDescModel.h"
#import "CSPopDescCell.h"

@interface CSPopDescriptionController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *sectionArr;


@end


@implementation CSPopDescriptionController

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)sectionArr {
    if (!_sectionArr) {
        _sectionArr = [NSMutableArray array];
    }
    return _sectionArr;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentSizeInPopup = CGSizeMake(SCREENWIDTH * 0.7, SCREENWIDTH * 0.9);             // 竖屏
        self.landscapeContentSizeInPopup = CGSizeMake(SCREENWIDTH * 0.9, SCREENWIDTH * 0.6);    // 横屏
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    
    UIButton *naviRightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [naviRightButton1 setTitle:@"" forState:UIControlStateNormal];
    [naviRightButton1 setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
    naviRightButton1.titleLabel.font = CS_UIFontSize(14.);
    naviRightButton1.frame = CGRectMake(0, 0, 40, 40);
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:naviRightButton1]];
    [naviRightButton1 addTarget:self action:@selector(dismissPop) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *naviRightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [naviRightButton2 setTitle:@"确定" forState:UIControlStateNormal];
    [naviRightButton2 setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
    naviRightButton2.titleLabel.font = CS_UIFontSize(14.);
    naviRightButton2.frame = CGRectMake(0, 0, 40, 40);
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:naviRightButton2]];
    [naviRightButton2 addTarget:self action:@selector(dismissPop) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *sectionArr = [NSArray array];
    NSArray *rowArr = [NSArray array];
    
    if (self.popDescType == popDescriptionTypeCoupon) {
        sectionArr = [CSPopDescModel getCouponSectionDescData];
        rowArr = [CSPopDescModel getCouponRowDescData];
    }else if (self.popDescType == popDescriptionTypeRegist) {
        sectionArr = [CSPopDescModel getRegistSectionDescData];
        rowArr = [CSPopDescModel getRegistRowDescData];
    }else if (self.popDescType == popDescriptionTypePurchase) {
        sectionArr = [CSPopDescModel getPurchaseSectionDescData];
        rowArr = [CSPopDescModel getPurchaseRowDescData];
    }else { }
    
    
    
    
    
    for (NSDictionary *dic in sectionArr) {
        CSPopDescModel *model = [CSPopDescModel mj_objectWithKeyValues:dic];
        [self.sectionArr addObject:model];
    }
    for (NSArray *arr in rowArr) {
        NSMutableArray *rowArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            CSPopDescModel *model = [CSPopDescModel mj_objectWithKeyValues:dic];
            [rowArr addObject:model];
        }
        [self.dataSource addObject:rowArr];
    }
    
    [self.tableView reloadData];
    
}

- (void)setPopDescType:(popDescriptionType)popDescType {
    _popDescType = popDescType;
    if (popDescType == popDescriptionTypeCoupon) {
        self.title = @"优惠券说明";
    }else if (popDescType == popDescriptionTypeRegist) {
        self.title = @"注册必读";
    }else if (popDescType == popDescriptionTypePurchase) {
        self.title = @"购买须知";
    }else { }
}

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[CSPopDescCell class] forCellReuseIdentifier:@"CSPopDescCellIdentifier"];
    
    self.tableView = tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPopDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSPopDescCellIdentifier"];
    if (!cell) {
        cell = [[CSPopDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CSPopDescCellIdentifier"];
    }
    cell.descModel = self.dataSource[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPopDescModel *model = self.dataSource[indexPath.section][indexPath.row];
    return model.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CSPopDescModel *model = self.sectionArr[section];
    return model.sectionHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CSPopDescModel *model = self.sectionArr[section];
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH * 0.7, model.sectionHeight)];
    UILabel *sectionDescLabel = [UILabel new];
    sectionDescLabel.font = CS_UIFontBoldSize(16.);
    sectionDescLabel.textColor = [UIColor buttonTitleColor];
    sectionDescLabel.numberOfLines = 0;
    [sectionView addSubview:sectionDescLabel];
    sectionDescLabel.text = model.sectionTitle;
    
    [sectionDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionView).offset(10);
        make.right.equalTo(sectionView).offset(-10);
        make.centerY.equalTo(sectionView.mas_centerY);
    }];
    
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (void)dismissPop {
    [self.popupController dismiss];
}

@end



































































































