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
@property(nonatomic,assign)CGFloat totalBtnWidth;


@end

@implementation LYBtn

// lazy
-(NSMutableArray *)mutBtnArr{
    if (!_mutBtnArr) {
        _mutBtnArr = [NSMutableArray array];
    }
    return _mutBtnArr;
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
        [self.menuScrollView addSubview:btn];
    }
    self.menuScrollView.contentSize = CGSizeMake(self.totalBtnWidth, 0);
    ((UIButton *)[self.mutBtnArr objectAtIndex:0]).selected = YES;
    ((UIButton *)[self.mutBtnArr objectAtIndex:0]).titleLabel.font = [UIFont systemFontOfSize:BTSFont];
    UIView *colorLine = [[UIView alloc] initWithFrame:CGRectMake(((UIButton *)[self.mutBtnArr objectAtIndex:0]).frame.size.width/2 - LineW/2 + ((UIButton *)[self.mutBtnArr objectAtIndex:0]).frame.origin.x, VHeight - 2, LineW, 2)];
    colorLine.backgroundColor = BSColor;
    self.colorLine = colorLine;
    [self.menuScrollView addSubview:self.colorLine];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, VHeight - 0.5, MainWidth, 0.5)];
    grayView.backgroundColor = GrayColor;
    [self addSubview:grayView];
}

-(void)bottomBtnClick:(UIButton *)button{
    [self.mutBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleLabel.font = [UIFont systemFontOfSize:15];
        obj.selected = NO;
    }];
    button.selected = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.colorLine.frame = CGRectMake(button.center.x - LineW/2, self.colorLine.frame.origin.y, self.colorLine.frame.size.width, self.colorLine.frame.size.height);
    }];
    
    [self moveLineWithBtn:button];
//    self.selectedItemIndex = button.tag;
    
    !_selectedBtnTag ? : _selectedBtnTag(button.tag);
}

-(void)moveLineWithBtn:(UIButton *)selectedBtn{
    if (CGRectEqualToRect(self.bgView.frame, CGRectZero)) {
        return;
    }
    // 转换点的坐标位置
    CGPoint centerInPageMenu = [self.bgView convertPoint:selectedBtn.center toView:self];
    // CGRectGetMidX(self.backgroundView.frame)指的是屏幕水平中心位置，它的值是固定不变的
    CGFloat offSetX = centerInPageMenu.x - CGRectGetMidX(self.bgView.frame);

    // itemScrollView的容量宽与自身宽之差(难点)
    CGFloat maxOffsetX = self.menuScrollView.contentSize.width - self.menuScrollView.frame.size.width;
    // 如果选中的button中心x值小于或者等于itemScrollView的中心x值，或者itemScrollView的容量宽度小于itemScrollView本身，此时点击button时不发生任何偏移，置offSetX为0
    if (offSetX <= 0 || maxOffsetX <= 0) {
        offSetX = 0;
    }
    // 如果offSetX大于maxOffsetX,说明itemScrollView已经滑到尽头，此时button也发生任何偏移了
    else if (offSetX > maxOffsetX){
        offSetX = maxOffsetX;
    }
    [self.menuScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}

- (CGRect)getSize:(CGFloat)lessWidth str:(NSString *)str{
    CGRect labelSize = [str boundingRectWithSize:CGSizeMake(MainWidth-lessWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil];
    return labelSize;
}


//#pragma mark - setter
//
//- (void)setBgScrollView:(UIScrollView *)bgScrollView {
//    _bgScrollView = bgScrollView;
//    if (bgScrollView) {
//        [bgScrollView addObserver:self forKeyPath:scrollViewContentOffset options:NSKeyValueObservingOptionNew context:nil];
//    } else {
//        NSLog(@"你传了一个空的scrollView");
//    }
//}
//
//#pragma mark - KVO
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if (object == self.bgScrollView) {
//        if ([keyPath isEqualToString:scrollViewContentOffset]) {
//            // 当scrolllView滚动时,让跟踪器跟随scrollView滑动
//            [self beginMoveTrackerFollowScrollView:self.bgScrollView];
//        }
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
//
//- (void)beginMoveTrackerFollowScrollView:(UIScrollView *)scrollView {
//
//    // 这个if条件的意思就是没有滑动的意思
//    if (!scrollView.dragging && !scrollView.decelerating) {return;}
//
//    // 当滑到边界时，继续通过scrollView的bouces效果滑动时，直接return
//    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width-scrollView.bounds.size.width) {
//        return;
//    }
//
//    static int i = 0;
//    if (i == 0) {
//        // 记录起始偏移量，注意千万不能每次都记录，只需要第一次纪录即可。
//        // 初始值不要等于scrollView.contentOffset.x,因为第一次进入此方法时，scrollView.contentOffset.x的值已经有一点点偏移了，不是很准确
//        _beginOffsetX = scrollView.bounds.size.width * self.selectedItemIndex;
//        i = 1;
//    }
//    // 当前偏移量
//    CGFloat currentOffSetX = scrollView.contentOffset.x;
//    // 偏移进度
//    CGFloat offsetProgress = currentOffSetX / scrollView.bounds.size.width;
//    CGFloat progress = offsetProgress - floor(offsetProgress);
//
//    NSInteger fromIndex;
//    NSInteger toIndex;
//
//    // 以下注释的“拖拽”一词很准确，不可说成滑动，例如:当手指向右拖拽，还未拖到一半时就松开手，接下来scrollView则会往回滑动，这个往回，就是向左滑动，这也是_beginOffsetX不可时刻纪录的原因，如果时刻纪录，那么往回(向左)滑动时会被视为“向左拖拽”,然而，这个往回却是由“向右拖拽”而导致的
//    if (currentOffSetX - _beginOffsetX > 0) { // 向左拖拽了
//        // 求商,获取上一个item的下标
//        fromIndex = currentOffSetX / scrollView.bounds.size.width;
//        // 当前item的下标等于上一个item的下标加1
//        toIndex = fromIndex + 1;
//        if (toIndex >= self.mutBtnArr.count) {
//            toIndex = fromIndex;
//        }
//    } else if (currentOffSetX - _beginOffsetX < 0) {  // 向右拖拽了
//        toIndex = currentOffSetX / scrollView.bounds.size.width;
//        fromIndex = toIndex + 1;
//        progress = 1.0 - progress;
//
//    } else {
//        progress = 1.0;
//        fromIndex = self.selectedItemIndex;
//        toIndex = fromIndex;
//    }
//
//    if (currentOffSetX == scrollView.bounds.size.width * fromIndex) {// 滚动停止了
//        progress = 1.0;
//        toIndex = fromIndex;
//    }
//
//    // 如果滚动停止，直接通过点击按钮选中toIndex对应的item
//    if (currentOffSetX == scrollView.bounds.size.width*toIndex) { // 这里toIndex==fromIndex
//        i = 0;
//        // 这一次赋值起到2个作用，一是点击toIndex对应的按钮，走一遍代理方法,二是弥补跟踪器的结束跟踪，因为本方法是在scrollViewDidScroll中调用，可能离滚动结束还有一丁点的距离，本方法就不调了,最终导致外界还要在scrollView滚动结束的方法里self.selectedItemIndex进行赋值,直接在这里赋值可以让外界不用做此操作
//        self.selectedItemIndex = toIndex;
//        // 要return，点击了按钮，跟踪器自然会跟着被点击的按钮走
//        return;
//    }
//    // 没有关闭跟踪模式
////    if (!self.closeTrackerFollowingMode) {
////        [self moveTrackerWithProgress:progress fromIndex:fromIndex toIndex:toIndex currentOffsetX:currentOffSetX beginOffsetX:_beginOffsetX];
////    }
//}
//
//- (void)dealloc {
//    [self.bgScrollView removeObserver:self forKeyPath:scrollViewContentOffset];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
