//
//  JMHomeHourController.m
//  XLMM
//
//  Created by zhang on 17/4/16.
//  Copyright © 2017年 上海但来. All rights reserved.
//

#import "JMHomeHourController.h"
#import "JMHomeHourCell.h"
#import "JMHomeHourModel.h"
#import "JMGoodsDetailController.h"
#import "JumpUtils.h"
#import "CSShareManager.h"


@interface JMHomeHourController () <UITableViewDelegate,UITableViewDataSource,JMHomeHourCellDelegate> {
    NSString *_nextPageUrl;
    NSMutableArray *_numArray;
}

//上拉的标志
@property (nonatomic) BOOL isLoadMore;
@property (nonatomic, strong) JMShareModel *shareModel;
@property (nonatomic, strong) CSSharePopController *sharPopVC;

@end

@implementation JMHomeHourController
#pragma mark 懒加载
- (CSSharePopController *)sharPopVC {
    if (!_sharPopVC) {
        _sharPopVC = [[CSSharePopController alloc] init];
    }
    return _sharPopVC;
}
- (JMShareModel *)shareModel {
    if (!_shareModel) {
        _shareModel = [[JMShareModel alloc] init];
    }
    return _shareModel;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 60 - kAppTabBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 175.f;
        [_tableView registerClass:[JMHomeHourCell class] forCellReuseIdentifier:@"JMHomeHourCellIdentifier"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
#pragma mark 重写set方法
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}
#pragma mark 生命周期函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}
#pragma mark 网络请求,数据处理
- (void)loadShareData:(NSString *)urlString {
    [MBProgressHUD showLoading:@"正在分享..."];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:[urlString JMUrlEncodedString] WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        self.shareModel = [JMShareModel mj_objectWithKeyValues:responseObject];
        self.shareModel.share_type = @"link";
        self.sharPopVC.popViewHeight = kAppShareEarningViewHeight;
        self.sharPopVC.model = self.shareModel;
        [MBProgressHUD hideHUD];
        [self popShareView:kAppShareEarningViewHeight];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"分享失败"];
    } Progress:^(float progress) {
    }];
}

- (void)loadSharDataWithHour:(NSString *)urlString {
    [MBProgressHUD showLoading:@"正在分享..."];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSDictionary *shopInfo = responseObject[@"shop_info"];
        self.shareModel.share_type = @"link";
        self.shareModel.share_img = [shopInfo objectForKey:@"thumbnail"]; //图片
        self.shareModel.desc = [shopInfo objectForKey:@"desc"]; // 文字详情
        self.shareModel.title = [shopInfo objectForKey:@"name"]; //标题
        self.shareModel.share_link = [shopInfo objectForKey:@"shop_link"];
        self.sharPopVC.popViewHeight = kAppShareViewHeight;
        self.sharPopVC.model = self.shareModel;
        [MBProgressHUD hideHUD];
        [self popShareView:kAppShareViewHeight];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"分享失败"];
    } Progress:^(float progress) {
        
    }];
}
#pragma mark 弹出视图 (弹出分享界面)
- (void)popShareView:(CGFloat)popHeeight {
    [[CSShareManager manager] showSharepopViewController:self.sharPopVC withRootViewController:self WithBlock:^(BOOL dismiss) {
        
    }];
    
}
#pragma mark UITableView 代理实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMHomeHourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JMHomeHourCellIdentifier"];
    if (!cell) {
        cell = [[JMHomeHourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JMHomeHourCellIdentifier"];
    }
    if (self.dataSource.count == 0) {
        return nil;
    }
    JMHomeHourModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"Push_JMGoodsDetailController"];
    if (self.dataSource.count == 0) {
        return ;
    }
    JMHomeHourModel *model = self.dataSource[indexPath.row];
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = model.model_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark JMHomeHourCellDelegate 点击事件
- (void)composeHourCell:(JMHomeHourCell *)cell Model:(JMHomeHourModel *)model ButtonClick:(UIButton *)button {
    NSInteger mobClickIndex = button.tag - 100;
    NSArray *itemArr = @[@"产品介绍",@"单品分享",@"店铺分享"];
    NSDictionary *tempDict = @{@"code" : [NSString stringWithFormat:@"%@",itemArr[mobClickIndex]]};
    [MobClick event:@"JMHomeHourCell_ButtonClickIndex" attributes:tempDict];
    
    if (button.tag == 100) {
        JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
        detailVC.goodsID = model.model_id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if (button.tag == 101) {
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/share/model?model_id=%@",Root_URL,model.model_id];
        [self loadShareData:urlString];
    }else {
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushop/customer_shop", Root_URL];
        [self loadSharDataWithHour:urlString];
    }
}


@end
























/*
 #pragma mrak 刷新界面
 - (void)createPullFooterRefresh {
 kWeakSelf
 self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
 _isLoadMore = YES;
 [weakSelf loadMore];
 }];
 }
 - (void)endRefresh {
 if (_isLoadMore) {
 _isLoadMore = NO;
 [self.collectionView.mj_footer endRefreshing];
 }
 }
 - (void)loadMore {
 if ([NSString isStringEmpty:_nextPageUrl]) {
 [self endRefresh];
 [self.collectionView.mj_footer endRefreshingWithNoMoreData];
 //        [MBProgressHUD showMessage:@"加载完成,没有更多数据"];
 return;
 }
 [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrl WithParaments:nil WithSuccess:^(id responseObject) {
 if (!responseObject) return;
 [self fetchMoreData:responseObject];
 [self endRefresh];
 } WithFail:^(NSError *error) {
 [self endRefresh];
 } Progress:^(float progress) {
 
 }];
 }
 - (void)fetchMoreData:(NSDictionary *)goodsDic {
 _nextPageUrl = goodsDic[@"next"];
 NSArray *resultsArr = goodsDic[@"results"];
 if (resultsArr.count == 0) {
 return ;
 }
 _numArray = [NSMutableArray array];
 for (NSDictionary *dic in resultsArr) {
 JMHomeHourModel *model = [JMHomeHourModel mj_objectWithKeyValues:dic];
 NSIndexPath *index ;
 index = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
 [self.dataSource addObject:model];
 [_numArray addObject:index];
 
 }
 if((_numArray != nil) && (_numArray.count > 0)) {
 @try{
 [self.collectionView insertItemsAtIndexPaths:_numArray];
 [_numArray removeAllObjects];
 _numArray = nil;
 }
 @catch(NSException *except) {
 NSLog(@"DEBUG: failure to batch update.  %@", except.description);
 }
 }
 [self.collectionView reloadData];
 }
 */
























































