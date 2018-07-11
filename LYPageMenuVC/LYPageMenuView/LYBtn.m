//
//  LYBtn.m
//  LYPageMenuVC
//
//  Created by Lee on 2018/7/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LYBtn.h"

#define MainWidth [UIScreen mainScreen].bounds.size.width

#define VWidth   self.frame.size.width
#define VHeight  self.frame.size.height
#define BSpace   20//btn title长度额外增加的宽度

#define BNColor   [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1]
#define BSColor   [UIColor colorWithRed:255.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1]
#define GrayColor [UIColor colorWithRed:193.0/255.0 green:192.0/255.0 blue:197.0/255.0 alpha:1]
#define BTNFont  15//普通状态字体大小
#define BTSFont  17//选中状态字体大小

#define LineW    25//colorLine宽度

#define scrollViewContentOffset @"contentOffset"

@interface LYBtn()

@property(nonatomic,strong)NSMutableArray *mutBtnArr;
@property(nonatomic,strong)NSMutableArray *widthArr;
@property(nonatomic,assign)CGFloat totalBtnWidth;

@end

@implementation LYBtn{
    UIButton *_preBtn;//记录之前的btn
}

// lazy
-(NSMutableArray *)mutBtnArr{
    if (!_mutBtnArr) {
        _mutBtnArr = [NSMutableArray array];
    }
    return _mutBtnArr;
}

-(NSMutableArray *)widthArr{
    if (!_widthArr) {
        _widthArr = [NSMutableArray array];
    }
    return _widthArr;
}

// init
-(id)initWithFrame:(CGRect)frame arr:(NSArray *)arr
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI:arr];
    }
    return self;
}

// setup
-(void)setupUI:(NSArray *)arr{
    self.backgroundColor = [UIColor redColor];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VWidth, VHeight)];
    bgView.backgroundColor = [UIColor yellowColor];
    self.bgView = bgView;
    [self addSubview:self.bgView];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, VWidth, VHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView = scrollView;
    [self addSubview:self.menuScrollView];
    [self createBtn:arr];
}

-(void)createBtn:(NSArray *)arr{
    
    for (NSInteger i = 0; i < arr.count; i++) {
        CGFloat btnWidth = ([self getSize:VWidth/2 str:arr[i]].size.width + BSpace) * arr.count < VWidth ? VWidth/arr.count : [self getSize:VWidth/2 str:arr[i]].size.width + BSpace;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.totalBtnWidth, 0, btnWidth, VHeight);
        self.totalBtnWidth += btnWidth;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:BNColor forState:UIControlStateNormal];
        [btn setTitleColor:BSColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:BTNFont];
        btn.tag = i;
        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mutBtnArr addObject:btn];
        [self.widthArr addObject:[NSNumber numberWithDouble:CGRectGetWidth(btn.frame)]];
        [self.menuScrollView addSubview:btn];
    }
    self.menuScrollView.contentSize = CGSizeMake(self.totalBtnWidth, 0);
    ((UIButton *)[self.mutBtnArr objectAtIndex:0]).selected = YES;
    ((UIButton *)[self.mutBtnArr objectAtIndex:0]).titleLabel.font = [UIFont boldSystemFontOfSize:BTSFont];
    UIView *colorLine = [[UIView alloc] initWithFrame:CGRectMake(((UIButton *)[self.mutBtnArr objectAtIndex:0]).frame.size.width/2 - LineW/2 + ((UIButton *)[self.mutBtnArr objectAtIndex:0]).frame.origin.x, VHeight - 2, LineW, 2)];
    colorLine.backgroundColor = BSColor;
    self.colorLine = colorLine;
    [self.menuScrollView addSubview:self.colorLine];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, VHeight - 0.5, MainWidth, 0.5)];
    grayView.backgroundColor = GrayColor;
    [self addSubview:grayView];
}

-(void)bottomBtnClick:(UIButton *)button{
    
    //记录上一个btn的tag，与点击的btn的tag作对比，如果为1或者-1说明相邻则bgScrollView滚动有动画，反之无动画
    NSInteger a = _preBtn.tag;
    NSInteger b = button.tag;
    _preBtn = button;
    [self.bgScrollView setContentOffset:CGPointMake(button.tag*MainWidth, 0) animated:(b-a == 1 || b-a == -1) ? YES : NO];
    
    [self.mutBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleLabel.font = [UIFont systemFontOfSize:BTNFont];
        obj.selected = NO;
    }];
    button.selected = YES;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:BTSFont];
    
    [self moveLineWithBtn:button];
    
    !_selectedBtnTag ? : _selectedBtnTag(button.tag);
}

-(void)moveLineWithBtn:(UIButton *)selectedBtn{
    
    [UIView animateWithDuration:0.1 animations:^{
        self.colorLine.frame = CGRectMake(selectedBtn.center.x - LineW/2, self.colorLine.frame.origin.y, self.colorLine.frame.size.width, self.colorLine.frame.size.height);
    }];
    
    if (CGRectEqualToRect(self.bgView.frame, CGRectZero)) {
        return;
    }
    // 转换点的坐标位置
    CGPoint centerInPageMenu = [self.bgView convertPoint:selectedBtn.center toView:self];
    // CGRectGetMidX(self.bgView.frame)指的是屏幕水平中心位置，它的值是固定不变的
    CGFloat offSetX = centerInPageMenu.x - CGRectGetMidX(self.bgView.frame);

    // menuScrollView的容量宽与自身宽之差(难点)
    CGFloat maxOffsetX = self.menuScrollView.contentSize.width - self.menuScrollView.frame.size.width;
    // 如果选中的button中心x值小于或者等于menuScrollView的中心x值，或者menuScrollView的容量宽度小于menuScrollView本身，此时点击button时不发生任何偏移，置offSetX为0
    if (offSetX <= 0 || maxOffsetX <= 0) {
        offSetX = 0;
    }
    // 如果offSetX大于maxOffsetX,说明menuScrollView已经滑到尽头，此时button也不发生任何偏移了
    else if (offSetX > maxOffsetX){
        offSetX = maxOffsetX;
    }
    [self.menuScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}

- (CGRect)getSize:(CGFloat)lessWidth str:(NSString *)str{
    CGRect labelSize = [str boundingRectWithSize:CGSizeMake(MainWidth-lessWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil];
    return labelSize;
}

#pragma mark - setter
- (void)setBgScrollView:(UIScrollView *)bgScrollView {
    _bgScrollView = bgScrollView;
    if (bgScrollView) {
        [bgScrollView addObserver:self forKeyPath:scrollViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
    } else {
        NSLog(@"你传了一个空的scrollView");
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.bgScrollView) {
        if ([keyPath isEqualToString:scrollViewContentOffset]) {
            // 当scrolllView滚动时,让跟踪器跟随scrollView滑动
            [self beginMoveTrackerFollowScrollView:self.bgScrollView];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)beginMoveTrackerFollowScrollView:(UIScrollView *)scrollView {
    if (scrollView == self.bgScrollView) {
        //如果响应时间不是滑动bgScrollView，则不继续往下执行
        if (!scrollView.dragging && !scrollView.decelerating) {
            return;
        }
        
        //防止scrollView处于第一个的时候手势返回不能立马凑效(有略微的抖动现象)，权宜之计而已
        if (scrollView.contentOffset.x <= -0.000001 ){
            scrollView.bounces = NO;
        }else if (scrollView.contentOffset.x > 0 ){
            scrollView.bounces = YES;
        }
        
        CGFloat offsetX = scrollView.contentOffset.x;
//        NSLog(@"offsetX/MainWidth = %f",offsetX/MainWidth);
        [self.mutBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
            obj.titleLabel.font = [UIFont systemFontOfSize:BTNFont];
            if (idx == offsetX/MainWidth) {
                obj.selected = YES;
                obj.titleLabel.font = [UIFont boldSystemFontOfSize:BTSFont];
                [self moveLineWithBtn:obj];
            }
        }];
    }
}

- (void)dealloc {
    NSLog(@"%@--dealloc",[self class]);
    [self.bgScrollView removeObserver:self forKeyPath:scrollViewContentOffset];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
