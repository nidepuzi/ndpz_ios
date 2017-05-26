//
//  CSInviteRecordingController.m
//  iOS_NDPZ
//
//  Created by zhang on 17/5/26.
//  Copyright © 2017年 danlai. All rights reserved.
//

#import "CSInviteRecordingController.h"
#import "HMSegmentedControl.h"
#import "CSInviteRecordingListController.h"


@interface CSInviteRecordingController () <UIScrollViewDelegate> {
    BOOL _isPullDown;       // 下拉刷新的标志
    BOOL _isLoadMore;       // 上拉加载的标志
    NSString *_nextPageUrl; // 下一页数据
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *baseScrollView;

@end

@implementation CSInviteRecordingController

#pragma mark ==== 懒加载 ====
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark ==== 生命周期函数 ====
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"" selecotr:@selector(backClick)];
    [self createcustomizeUI];
    
}

#pragma mark ==== 自定义UI ====
- (void)createcustomizeUI {
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 35)];
    segmentView.layer.cornerRadius = 5;
    segmentView.layer.masksToBounds = YES;
    segmentView.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentView.layer.borderWidth = 0.5f;
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 160, 35)];
    self.segmentedControl.sectionTitles = @[@"正式掌柜",@"试用掌柜"];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor buttonEnabledBackgroundColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:15.]};
    //        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleArrow;
    
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    self.segmentedControl.selectionIndicatorBoxOpacity = 1.0;
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentView addSubview:self.segmentedControl];
    self.navigationItem.titleView = segmentView;
    
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
    self.baseScrollView.showsHorizontalScrollIndicator = NO;
    self.baseScrollView.showsVerticalScrollIndicator = NO;
    self.baseScrollView.pagingEnabled = YES;
    self.baseScrollView.delegate = self;
    [self.view addSubview:self.baseScrollView];
    
    for (int i = 0 ; i < 2; i++) {
        CSInviteRecordingListController *fineVC = [[CSInviteRecordingListController alloc] init];
        if (i == 0) {
            fineVC.urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm/get_referal_mama?last_renew_type=full", Root_URL];
        }else {
            fineVC.urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/xlmm/get_referal_mama?last_renew_type=trial", Root_URL];
        }
        [self addChildViewController:fineVC];
        [fineVC didMoveToParentViewController:self];
    }
    self.baseScrollView.contentSize = CGSizeMake(SCREENWIDTH * 2, self.baseScrollView.frame.size.height);
    
    
    [self removeToPage:0];
    
    
}
- (void)removeToPage:(NSInteger)index {
    self.baseScrollView.contentOffset = CGPointMake(SCREENWIDTH * index, 0);
    CSInviteRecordingListController *homeFirst = self.childViewControllers[index];
    homeFirst.view.frame = self.baseScrollView.bounds;
    [self.baseScrollView addSubview:homeFirst.view];
}


#pragma mark ==== 自定义点击事件 ====
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    NSInteger page = segmentedControl.selectedSegmentIndex;
    [self removeToPage:page];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    [self removeToPage:page];
    
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}



@end



































































































