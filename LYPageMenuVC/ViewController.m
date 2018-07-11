//
//  ViewController.m
//  LYPageMenuVC
//
//  Created by Lee on 2018/7/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ViewController.h"
#import "LYBtn.h"

#define MainWidth [UIScreen mainScreen].bounds.size.width
#define MainHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"封装pageMenu测试";
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    LYBtn *btnView = [[LYBtn alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40) arr:@[@"积极",@"响应",@"党",@"和",@"中央",@"号召",@"犯我中华者",@"虽远必诛"]];
    btnView.selectedBtnTag = ^(NSInteger btnTag) {
        NSLog(@"%ld",btnTag);
    };
    [self.view addSubview:btnView];
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, MainWidth, MainHeight - 49)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    btnView.bgScrollView = self.scrollView;
    
    for (NSInteger i = 0; i < 9; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * MainWidth, 0, MainWidth, MainHeight - 49)];
        view.backgroundColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1];
        [self.scrollView addSubview:view];
//        self.scrollView.contentOffset = CGPointMake(MainWidth*btnView.selectedItemIndex, 0);
        self.scrollView.contentSize = CGSizeMake(i*MainWidth, 0);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
