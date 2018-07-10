//
//  LYBtn.h
//  LYPageMenuVC
//
//  Created by Lee on 2018/7/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectedBtnTag)(NSInteger btnTag);

@interface LYBtn : UIView

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIScrollView *menuScrollView;
@property(nonatomic,strong)UIView *colorLine;

//@property(nonatomic,strong)UIScrollView *bgScrollView;//外部传入的scrollView，监听其滚动，让跟踪器时刻跟随此scrollView滑动
//// 起始偏移量,为了判断滑动方向
//@property (nonatomic, assign) CGFloat beginOffsetX;
//@property(nonatomic,assign)NSInteger selectedItemIndex;

@property(nonatomic,copy)selectedBtnTag selectedBtnTag;


-(id)initWithFrame:(CGRect)frame arr:(NSArray *)arr;

@end
