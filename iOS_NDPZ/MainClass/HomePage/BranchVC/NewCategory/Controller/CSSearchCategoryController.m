//
//  CSSearchCategoryController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/18.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSSearchCategoryController.h"
#import "RootNavigationController.h"
#import "JMSearchViewController.h"
#import "CSRightContentController.h"
#import "JMClassifyListController.h"


#define leftContentWidth  SCREENWIDTH * 0.25
#define rightContentWidth SCREENWIDTH * 0.75

@interface CSSearchCategoryController () <UIScrollViewDelegate> {
    NSMutableArray *buttonArr;
    UIButton *_tmpBtn;
}


@property (nonatomic, strong) UIScrollView *baseScrollView;


@end


@implementation CSSearchCategoryController

- (NSMutableArray *)categoryItem {
    if (!_categoryItem) {
        _categoryItem = [NSMutableArray array];
    }
    return _categoryItem;
}
- (NSMutableArray *)categoryCid {
    if (!_categoryCid) {
        _categoryCid = [NSMutableArray array];
    }
    return _categoryCid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"精选分类" selecotr:@selector(backClick)];
    _tmpBtn = nil;
    [self createSearchBarView];
    
    if (self.categoryItem.count == 0) {
        [self loadDataCategory];
    }else {
        [self createUI];
    }
    
    
    
    
    
}
- (void)loadDataCategory {
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/portal?exclude_fields=activitys",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        [self fetchCategoryData:responseObject];
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showMessage:@"加载失败"];
    } Progress:^(float progress) {
    }];
}
- (void)fetchCategoryData:(NSDictionary *)categoryDic {
    NSArray *categorys = categoryDic[@"categorys"];
    for (NSDictionary *dic in categorys) {
        [self.categoryItem addObject:dic[@"name"]];
        [self.categoryCid addObject:dic[@"id"]];
    }
    
//    [self createSearchBarView];
    [self createUI];
    
}

#pragma mark ==== 创建UI ====
- (void)createUI {
    UIScrollView *leftView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kAPPNavigationHeight, leftContentWidth, SCREENHEIGHT - kAPPNavigationHeight)];
    leftView.backgroundColor = [UIColor countLabelColor];
    
    [self.view addSubview:leftView];
    buttonArr = [NSMutableArray array];
    for (int i = 0; i < self.categoryItem.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftView addSubview:button];
        button.backgroundColor = [UIColor countLabelColor];
        button.titleLabel.font = CS_UIFontSize(13.);
        [button setTitle:self.categoryItem[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        
        button.frame = CGRectMake(0 , 60 * (i % 4), leftContentWidth, 60);
        
        if (i == 0) {
            button.selected = YES;
            button.backgroundColor = [UIColor whiteColor];
            _tmpBtn = button;
        }
//        [buttonArr addObject:button];
        
    }
    
    leftView.contentSize = CGSizeMake(leftContentWidth, self.categoryItem.count * 60);
    
    
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftView.cs_max_X, kAPPNavigationHeight, rightContentWidth, SCREENHEIGHT - kAPPNavigationHeight)];
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.delegate = self;
    self.baseScrollView.scrollEnabled = NO;
    [self.view addSubview:self.baseScrollView];
    
    for (int i = 0 ; i < self.categoryItem.count; i++) {
        CSRightContentController *childCategoryVC = [[CSRightContentController alloc] init];
        childCategoryVC.urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts?cid=%@", Root_URL,self.categoryCid[i]];
        [self addChildViewController:childCategoryVC];
        [childCategoryVC didMoveToParentViewController:self];
    }
    
    self.baseScrollView.contentSize = CGSizeMake(rightContentWidth, SCREENHEIGHT * self.categoryItem.count);
    [self removeToPage:0];
    
    
}

- (void)createSearchBarView {
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.cs_size = CGSizeMake(SCREENWIDTH - 80, 30);
    searchButton.backgroundColor = [UIColor lineGrayColor];
    [searchButton setImage:[UIImage imageNamed:@"searchBarImage"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"searchBarImage"] forState:UIControlStateSelected];
    [searchButton setTitle:@"查找所有精品" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 5.;
    
    self.navigationItem.titleView = searchButton;
}
#pragma mark 移动到某个子视图
- (void)removeToPage:(NSInteger)index {
    self.baseScrollView.contentOffset = CGPointMake(0, (SCREENHEIGHT - 64) * index);
    CSRightContentController *childCategoryVC = self.childViewControllers[index];
    childCategoryVC.view.frame = self.baseScrollView.bounds;
    [self.baseScrollView addSubview:childCategoryVC.view];
}


#pragma mark ==== 搜索框搜索事件 ====
- (void)searchButtonClick {
    JMSearchViewController *searchViewController = [JMSearchViewController searchViewControllerWithHistorySearchs:nil searchBarPlaceHolder:nil didSearchBlock:^(JMSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/search_by_name?name=%@",Root_URL,searchText];
        JMClassifyListController *searchVC = [[JMClassifyListController alloc] init];
        searchVC.titleString = searchText;
        searchVC.emptyTitle = @"搜索其他";
        searchVC.urlString = [urlString JMUrlEncodedString];
        [searchViewController.navigationController pushViewController:searchVC animated:YES];
    }];
    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:NO completion:nil];
}
- (void)leftButtonClick:(UIButton *)button {
    if (button == _tmpBtn) {
        return;
    }
    if (_tmpBtn == nil){
        button.selected = YES;
        button.backgroundColor = [UIColor whiteColor];
        _tmpBtn = button;
    }else if (_tmpBtn != nil && _tmpBtn == button){
        button.selected = YES;
        button.backgroundColor = [UIColor whiteColor];
    }else if (_tmpBtn != button && _tmpBtn != nil){
        _tmpBtn.selected = NO;
        _tmpBtn.backgroundColor = [UIColor countLabelColor];
        button.selected = YES;
        button.backgroundColor = [UIColor whiteColor];
        _tmpBtn = button;
    }
    
    
//    
//    for (UIButton *btn in buttonArr) {
//        if (btn == button) {
//            btn.selected = YES;
//            btn.backgroundColor = [UIColor whiteColor];
//        }else {
//            btn.selected = NO;
//            btn.backgroundColor = [UIColor countLabelColor];
//        }
//    }
    
    NSInteger index = button.tag - 100;
    [self removeToPage:index];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}





@end
















































































































