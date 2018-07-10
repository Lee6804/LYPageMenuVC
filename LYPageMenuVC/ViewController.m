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

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"封装pageMenu测试";
//    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    self.view.backgroundColor = [UIColor blueColor];
    LYBtn *btnView = [[LYBtn alloc] initWithFrame:CGRectMake(0, 64, MainWidth, 40) arr:@[@"积极",@"响应",@"党",@"和",@"中央",@"号召",@"犯我中华者",@"虽远必诛"]];
    btnView.selectedBtnTag = ^(NSInteger btnTag) {
        NSLog(@"%ld",btnTag);
    };
    [self.view addSubview:btnView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
