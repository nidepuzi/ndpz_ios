//
//  CSRightContentController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/18.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSRightContentController.h"
#import "JMReloadEmptyDataView.h"
#import "JMEmptyView.h"
#import "JMFineCouponModel.h"
#import "CSRightContentCell.h"
#import "JMGoodsDetailController.h"
#import "CSRightHeader.h"


@interface CSRightContentController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSString *_nextPageUrlString;
    BOOL _isPullDown;
    BOOL _isLoadMore;
    NSMutableArray *_numArray;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;
@property (nonatomic, strong) JMEmptyView *empty;


@end

@implementation CSRightContentController

#pragma mark 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark 生命周期函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.collectionView cs_reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"精选分类" selecotr:nil];
    
    [self createCollectionView];
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    
    [self.collectionView.mj_header beginRefreshing];

}



- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH * 0.75, SCREENHEIGHT - 64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[CSRightContentCell class] forCellWithReuseIdentifier:@"CSRightContentCellIdentifier"];
    
}

#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.collectionView.mj_header = [CSRightHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.collectionView.mj_footer resetNoMoreData];
        [weakSelf loadDataSource];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadMore];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.collectionView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.collectionView.mj_footer endRefreshing];
    }
}
- (void)loadDataSource {
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        NSLog(@"%@",responseObject);
        [self.dataSource removeAllObjects];
        [self fatchClassifyListData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)loadMore {
    if ([NSString isStringEmpty:_nextPageUrlString]) {
        [self endRefresh];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fatchClassifyListMoreData:responseObject];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}

- (void)fatchClassifyListData:(NSDictionary *)itemDic {
    _nextPageUrlString = itemDic[@"next"];
    NSArray *resultsArr = itemDic[@"results"];
    if (resultsArr.count != 0) {
        for (NSDictionary *dic in resultsArr) {
            JMFineCouponModel *model = [JMFineCouponModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
    }
    [self.collectionView cs_reloadData];
}
- (void)fatchClassifyListMoreData:(NSDictionary *)itemDic {
    _nextPageUrlString = itemDic[@"next"];
    NSArray *resultsArr = itemDic[@"results"];
    if (resultsArr.count != 0) {
        _numArray = [NSMutableArray array];
        
        for (NSDictionary *dic in resultsArr) {
            NSIndexPath *index ;
            index = [NSIndexPath indexPathForRow:self.dataSource.count inSection:0];
            JMFineCouponModel *model = [JMFineCouponModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
            [_numArray addObject:index];
        }
        if((_numArray != nil) && (_numArray.count > 0)){
            @try{
                [self.collectionView insertItemsAtIndexPaths:_numArray];
                [_numArray removeAllObjects];
                _numArray = nil;
            }
            @catch(NSException *except)
            {
                NSLog(@"DEBUG: failure to batch update.  %@", except.description);
            }
        }
    }
    [self.collectionView cs_reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSRightContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CSRightContentCellIdentifier" forIndexPath:indexPath];
    JMFineCouponModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake((SCREENWIDTH * 0.75 - 15) * 0.5, (SCREENWIDTH * 0.75 - 15) * 0.5 + 60);
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JMFineCouponModel *model = self.dataSource[indexPath.row];
    NSString *goodsID = model.fineCouponModelID;
    
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = goodsID;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 100, 0, 0) Title:@"暂时没有商品哦~" DescTitle:@"" ButtonTitle:@"" Image:@"data_empty" ReloadBlcok:^{
            //            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}





@end























































