//
//  DebugSettingViewController.m
//  XLMM
//
//  Created by wulei on 5/10/16.
//  Copyright © 2016 上海己美. All rights reserved.
//

#import "DebugSettingViewController.h"
#import "LGViews.h"
#import "MiPushSDK.h"

//动画时间
#define kAnimationDuration 0.2
//view高度
#define kViewHeight 56


@interface DebugSettingViewController ()<UITextViewDelegate>{
    NSString *serverip;
    NSString *pwd;
}

@property (strong, nonatomic) UIScrollView          *scrollView;
@property (strong, nonatomic) LGRadioButtonsView    *radioButtons1;
@property (strong, nonatomic) UITextView    *tvip;
@property (strong, nonatomic) UITextView    *tvpwd;
@property (strong, nonatomic) UIButton    *btn;



@end

@implementation DebugSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    //添加键盘的监听事件
    
    //注册通知,监听键盘弹出事件
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //注册通知,监听键盘消失事件
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    
    [MobClick beginLogPageView:@"DebugSettingViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [JMNotificationCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [JMNotificationCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [MobClick endLogPageView:@"DebugSettingViewController"];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        [self createNavigationBarWithTitle:@"Debug设置" selecotr:@selector(backClicked:)];
    
    serverip = @"";
    pwd = @"";
    [self initView];
}

- (void)initView{
    
    // -----
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.tag = 1000;
    [self.view addSubview:_scrollView];
    
    UIImage *circleImageNormal = [UIImage imageNamed:@"circle_wallet_Normal1"];
    
    UIImage *circleImageHighlighted = [UIImage imageNamed:@"circle_wallet_Selected1"];
    
    _radioButtons1 = [[LGRadioButtonsView alloc] initWithNumberOfButtons:7
       actionHandler:^(LGRadioButtonsView *radioButtonsView, NSString *title, NSUInteger index)
                      {
                          NSLog(@"%@, %i", title, (int)index);
                          switch (index) {
                              case 0:
                                  serverip = @"https://m.xiaolumeimei.com";
                                  break;
                              case 1:
                                  serverip = @"http://staging.xiaolumm.com";
                                  break;
                              case 2:
                                  serverip = @"http://warden.xiaolumm.com";
                                  break;
                              case 3:
                                  serverip = @"http://s18.xiaolumm.com";
                                  break;
                              case 4:
                                  serverip = @"http://192.168.1.31:9000";
                                  break;
                              case 5:
                                  serverip = @"http://192.168.1.8:8888";
                                  break;
                              case 6:
                                  serverip = @"http://192.168.1.11:9000";
                                  break;
                                  
                              default:
                                  break;
                          }
                      }];
    _radioButtons1.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.f];
    _radioButtons1.contentEdgeInsets = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
    [_radioButtons1 setButtonsTitles:@[@"m.xiaolumeimei.com", @"staging.xiaolumm.com", @"warden.xiaolumm.com",  @"s18.xiaolumm.com", @"192.168.1.31:9000", @"192.168.1.8:8888", @"192.168.1.11:9000"] forState:UIControlStateNormal];
//    [_radioButtons1 setButtonsContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_radioButtons1 setButtonsTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_radioButtons1 setButtonsImage:circleImageNormal forState:UIControlStateNormal];
    [_radioButtons1 setButtonsImage:circleImageHighlighted forState:UIControlStateHighlighted];
    [_radioButtons1 setButtonsImage:circleImageHighlighted forState:UIControlStateSelected];
    [_radioButtons1 setButtonsAdjustsImageWhenHighlighted:NO];
    [_radioButtons1 setButtonsContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [_scrollView addSubview:_radioButtons1];
    
    _scrollView.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    
    CGFloat shift = 10.f;
    
    CGSize radioButtonsSize1 = [_radioButtons1 sizeThatFits:CGSizeMake(self.view.frame.size.width-shift*2, CGFLOAT_MAX)];
    CGRect radioButtonsFrame1 = CGRectMake(shift, shift, radioButtonsSize1.width, radioButtonsSize1.height);
    radioButtonsFrame1 = CGRectIntegral(radioButtonsFrame1);
    _radioButtons1.frame = radioButtonsFrame1;
    

    
    self.tvip= [[UITextView alloc] initWithFrame:CGRectMake(0.f+10, _radioButtons1.frame.size.height + 20, self.view.frame.size.width-20, 30)];
    self.tvip.text = @"输入ip地址端口号，如192.168.1.11:9000";
    self.tvip.delegate = self;
    self.tvip.scrollEnabled = NO;
    self.tvip.tag = 100;
    //返回键的类型
    self.tvip.returnKeyType = UIReturnKeyDefault;
    //键盘类型
    self.tvip.keyboardType = UIKeyboardTypeDefault;
    //[self.tvip becomeFirstResponder];
    
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    
    [self.tvip setInputAccessoryView:topView];
    [_scrollView addSubview:self.tvip];

    self.tvpwd= [[UITextView alloc] initWithFrame:CGRectMake(0.f+10, _radioButtons1.frame.size.height + 60, self.view.frame.size.width - 20, 30)];
    self.tvpwd.text = @"输入密码";
    self.tvpwd.delegate = self;
    self.tvpwd.tag = 101;
    [self.tvpwd setInputAccessoryView:topView];

    [_scrollView addSubview:self.tvpwd];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(0.f+80, _radioButtons1.frame.size.height + 100, 160, 30)];
    [self.btn  setTitle:@"提交" forState:UIControlStateNormal];//设置button的title
    self.btn.backgroundColor = [UIColor buttonEnabledBackgroundColor];//button的背景颜色
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.btn];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, self.btn.frame.origin.y+self.btn.frame.size.height+shift);
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    //调整放置有textView的view的位置
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:kAnimationDuration];
    
    //设置view的frame，往上平移
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height-_scrollView.frame.size.height, self.view.frame.size.width, _scrollView.frame.size.height)];
    
    [UIView commitAnimations];
    
}

//键盘消失时
-(void)keyboardDidHidden
{
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    [(UIView *)[self.view viewWithTag:1000] setFrame:CGRectMake(0, self.view.frame.size.height-_scrollView.frame.size.height, self.view.frame.size.width, _scrollView.frame.size.height)];
    [UIView commitAnimations];
}

- (void)resignKeyboard{
    [self.tvip resignFirstResponder];
    [self.tvpwd resignFirstResponder];
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //隐藏键盘
//    [self.tvip resignFirstResponder];
//    [self.tvpwd resignFirstResponder];
//}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@""])
//    {
//        [self.tvip resignFirstResponder];
//        return NO;
//    }
//    return YES; 
//}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView

{
    if(textView.tag == 100 || textView.tag ==101){
        textView.text=@"";
        textView.tag = 0;
    }
    
    return YES;
    
}

-(void)btnClick {
    if([serverip isEqualToString:@""]){
        serverip = self.tvip.text;
    }
    
    pwd = self.tvpwd.text;
    if([serverip isEqualToString:@""]  || [pwd isEqualToString:@""]){
        [MBProgressHUD showError:@"ip or password is empty"];
        return;
    }
    
    [serverip stringByAppendingString:@"/rest/v1/users/open_debug_for_app"];
    NSDictionary *newDic = @{@"debug_secret":pwd};
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/open_debug_for_app", Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:newDic WithSuccess:^(id responseObject) {
        NSDictionary *dic = responseObject;
        NSString *rcode = [dic objectForKey:@"rcode"];
        if([rcode integerValue] == 0){
            NSLog(@"debug check success");
            [self logout];
            [JMUserDefaults setBool:NO forKey:kIsLogin];
            Root_URL = serverip;
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"switch to server %@", serverip]];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [JMNotificationCenter postNotificationName:@"fromActivityToToday" object:nil userInfo:@{@"param":@"today"}];
        }
        else{
            NSLog(@"debug check failed");
            [MBProgressHUD showError:@"debug check failed"];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"debug check failed"];
    } Progress:^(float progress) {
        
    }];
}


- (void)logout {
    //退出    
    //   http://m.xiaolu.so/rest/v1/users/customer_logout
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/users/customer_logout", Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([[dic objectForKey:@"code"] integerValue] != 0) return;
        //注销账号
        NSString *user_account = [JMUserDefaults objectForKey:@"user_account"];
        if (!([user_account isEqualToString:@""] || [user_account class] == [NSNull null])) {
            [MiPushSDK unsetAccount:user_account];
            [JMUserDefaults setObject:@"" forKey:@"user_account"];
        }
        [JMUserDefaults setBool:NO forKey:kIsLogin];
        [JMUserDefaults setObject:@"unlogin" forKey:kLoginMethod];
        [JMUserDefaults setBool:NO forKey:kISXLMM];
        [JMUserDefaults synchronize];
        [JMNotificationCenter postNotificationName:@"logout" object:nil];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];

    
}

@end











































