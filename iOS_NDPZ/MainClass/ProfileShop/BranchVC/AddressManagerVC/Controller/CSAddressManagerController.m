//
//  CSAddressManagerController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/5.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSAddressManagerController.h"
#import "JMEmptyView.h"
#import "JMAddressModel.h"
#import "CSAddressManagerCell.h"
#import "JMModifyAddressController.h"
#import "JMReloadEmptyDataView.h"

@interface CSAddressManagerController () <UITableViewDelegate, UITableViewDataSource, CSAddressManagerCellDelegate, CSTableViewPlaceHolderDelegate>

@property (nonatomic, strong) JMEmptyView *empty;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JMAddressModel *addressModel;
@property (nonatomic, strong) UIButton *addAddressButton;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;

@end

static NSString *CSAddressManagerCellIdentifier = @"CSAddressManagerCellIdentifier";

@implementation CSAddressManagerController

- (JMAddressModel *)addressModel {
    if (!_addressModel) {
        _addressModel = [[JMAddressModel alloc] init];
    }
    return _addressModel;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 60) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor countLabelColor];
        [_tableView registerClass:[CSAddressManagerCell class] forCellReuseIdentifier:CSAddressManagerCellIdentifier];
        _tableView.rowHeight = 180;
    }
    return _tableView;
}
- (UIButton *)addAddressButton {
    if (!_addAddressButton) {
        _addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addAddressButton.frame = CGRectMake(0, SCREENHEIGHT - 60, SCREENWIDTH, 60);
        _addAddressButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
//        _addAddressButton.layer.masksToBounds = YES;
//        _addAddressButton.layer.cornerRadius = 20.f;
        [_addAddressButton setTitle:@"添加新地址" forState:UIControlStateNormal];
        [_addAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addAddressButton.titleLabel.font = [UIFont systemFontOfSize:16.];
        [_addAddressButton addTarget:self action:@selector(addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressButton;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadAddressData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"收货地址管理" selecotr:@selector(backClick)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addAddressButton];
    


}
#pragma mark 网络请求,数据处理
- (void)loadAddressData {
    [MBProgressHUD showLoading:@""];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:kAddress_List_URL WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        [self.dataSource removeAllObjects];
        [self fatchedAddressData:responseObject];
        [self.tableView cs_reloadData];
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
    }];
}
- (void)fatchedAddressData:(NSArray *)allArr {
    if (allArr.count == 0) {
        return ;
    }
    for (NSDictionary *dic in allArr) {
        JMAddressModel *model = [JMAddressModel mj_objectWithKeyValues:dic];
        [self.dataSource addObject:model];
    }
}
- (void)deleteAddress:(JMAddressModel *)model {
    NSString *deleteurlString = [NSString stringWithFormat:@"%@/rest/v1/address/%@/delete_address", Root_URL,model.addressID];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:deleteurlString WithParaments:nil WithSuccess:^(id responseObject) {
        [self loadAddressData];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}


#pragma mark 代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSAddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:CSAddressManagerCellIdentifier];
    if (!cell) {
        cell = [[CSAddressManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CSAddressManagerCellIdentifier];
    }
    JMAddressModel *model = self.dataSource[indexPath.row];
    cell.addressModel = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMAddressModel *model = self.dataSource[indexPath.row];
    if (self.isSelected) {
        if (_delegate && [_delegate respondsToSelector:@selector(addressView:model:)]) {
            [_delegate addressView:self model:model];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else { }
}
- (void)modifyAddress:(JMAddressModel *)medel Button:(UIButton *)button {
    switch (button.tag) {
        case 100: {
            [MBProgressHUD showLoading:@""];
            NSString *string = [NSString stringWithFormat:@"%@/rest/v1/address/%@/change_default", Root_URL, medel.addressID];
            [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
                [MBProgressHUD hideHUD];
                [self loadAddressData];
            } WithFail:^(NSError *error) {
                [MBProgressHUD showMessage:@"设置默认失败"];
            } Progress:^(float progress) {
            }];
        }
            break;
        case 101: {
            JMModifyAddressController *addVC = [[JMModifyAddressController alloc] init];
            addVC.isAdd = NO;
            addVC.cartsPayInfoLevel = self.cartsPayInfoLevel;
            addVC.addressLevel = [medel.personalinfo_level integerValue];
            addVC.addressModel = medel;
            [self.navigationController pushViewController:addVC animated:YES];
        }
            break;
        case 102: {
            [self deleteAddress:medel];
        }
            break;
        default:
            break;
    }
}


#pragma mark 空视图
- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您还没有添加收货地址哦～" DescTitle:@"" ButtonTitle:@"添加新地址" Image:@"data_empty" ReloadBlcok:^{
            [self addAddressClick];
        }];
        _reload = reload;
    }
    return _reload;
}


#pragma mark 处理点击事件
- (void)addAddressClick {
    JMModifyAddressController *addVC = [[JMModifyAddressController alloc] init];
    addVC.isAdd = YES;
    addVC.cartsPayInfoLevel = self.cartsPayInfoLevel;
    addVC.addressLevel = 0;
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}





@end












































