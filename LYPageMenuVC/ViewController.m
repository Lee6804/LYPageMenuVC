//
//  ViewController.m
//  LYPageMenuVC
//
//  Created by Lee on 2018/7/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ViewController.h"
#import "LYBtn.h"
#import "OneViewController.h"

#define MainWidth [UIScreen mainScreen].bounds.size.width
#define MainHeight [UIScreen mainScreen].bounds.size.height

#define kScreenIphoneX (([[UIScreen mainScreen] bounds].size.height)==812)
#define TopHeight (kScreenIphoneX ? 88 : 64)*1.0

#define MenuHeight 40


@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *myChildVCS;

@end

@implementation ViewController

-(NSMutableArray *)myChildVCS{
    if (!_myChildVCS) {
        _myChildVCS = [NSMutableArray array];
    }
    return _myChildVCS;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"封装pageMenu测试";
    NSArray *titleArr = @[@"积极",@"响应",@"党",@"和",@"中央",@"号召",@"犯我中华者",@"虽远必诛"];
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    LYBtn *btnView = [[LYBtn alloc] initWithFrame:CGRectMake(0, TopHeight, MainWidth, MenuHeight) arr:titleArr];
    btnView.selectedBtnTag = ^(NSInteger btnTag) {
        NSLog(@"%ld",btnTag);
    };
    [self.view addSubview:btnView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopHeight + MenuHeight, MainWidth, MainHeight - TopHeight - MenuHeight)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(titleArr.count*MainWidth, 0);
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    btnView.bgScrollView = self.scrollView;
    
    /*添加View
     
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * MainWidth, 0, MainWidth, self.scrollView.frame.size.height)];
        view.backgroundColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1];
        [self.scrollView addSubview:view];
    }
     */
    
    //添加VC
    for (NSInteger i = 0; i < titleArr.count; i++) {
        OneViewController *oneVC = [[OneViewController alloc] init];
        oneVC.view.frame = CGRectMake(MainWidth*i, 0, MainWidth, self.scrollView.frame.size.height);
        [self addChildViewController:oneVC];
        [self.scrollView addSubview:oneVC.view];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
