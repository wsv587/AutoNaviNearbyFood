//
//  ViewController.m
//  GDMap
//
//  Created by sw on 17/5/19.
//  Copyright © 2017年 sw. All rights reserved.
//

#import "ViewController.h"
#import "FoodTableView.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,FoodTableViewDelegate>

@property(nonatomic,strong) UIButton *bottomButton;
@property(nonatomic,strong) FoodTableView *tableView;
@property(nonatomic,assign) CGFloat offsetY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];

    [self setupImageView];
    
    [self.view addSubview:self.tableView];
}

- (void)setupImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.userInteractionEnabled = YES;
    
    imageView.image = [UIImage imageNamed:@"screen"];
    
    [self.view addSubview:imageView];
}

#pragma mark - private
// 恢复tableView到最初的位置
- (void)resumeTableView {
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = self.view.bounds;
    }];
    [self.bottomButton removeFromSuperview];
    
}

// 下移隐藏tableView
- (void)hiddenTableView {
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, screenH, self.tableView.frame.size.width, self.tableView.frame.size.height);
    }];
    // 添加底部按钮
    [self.view addSubview:self.bottomButton];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.backgroundColor = [UIColor whiteColor];
    cell.alpha = 0.7;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    CGFloat curOffsetY = scrollView.contentOffset.y;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;

    if (curOffsetY > 0.f) {
        return;
    }
    
    if (curOffsetY > self.offsetY && curOffsetY > -240.f && curOffsetY < 0.f) { // 原位 -> up顶部
        // curOffsetY > self.offsetY 代表向上滚动
        // curOffsetY > -240.f 代表从初始位置向上滚动
        // curOffsetY < 0.f 代表tableView第一行还未滚动到顶部
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentOffset = CGPointMake(0.f, 0.f);
        }];
        
    } else if (curOffsetY < self.offsetY && curOffsetY < -240.f && curOffsetY > -screenH) { // 原位 -> down底部
        // curOffsetY < self.offsetY 代表向下滚动
        // curOffsetY < -240.f 代表从初始位置向下滚动
        // curOffsetY > -screenH 代表tableView第一行还未滚动到底部
        // 下移tableView
        [self hiddenTableView];
        
    } else if (curOffsetY > self.offsetY && curOffsetY < -240.f) { // 底部 -> up原位
        // curOffsetY > self.offsetY 代表向上滚动
        // curOffsetY < -240.f 代表是从底部向上滚动
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.frame = self.view.bounds;
//            scrollView.contentInset = UIEdgeInsetsMake(240.f, 0, 0, 0);
//            [scrollView layoutIfNeeded];
//            [scrollView setNeedsLayout];
        }];
        // 移除底部按钮
        [self.bottomButton removeFromSuperview];
    } else if (curOffsetY < self.offsetY && curOffsetY < 0.f && curOffsetY > -240.f) {  // resume 顶部 -> down原位
        // 从顶部向下滚动
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentOffset = CGPointMake(0.f, -240.f);
        }];
    }
    
    self.offsetY = scrollView.contentOffset.y;
}

#pragma mark - FoodTableViewDelegate
- (void)didTouchTableView:(FoodTableView *)tableView withLocation:(CGPoint)location {
    CGPoint locationInView = [tableView convertPoint:location toView:self.view];
    
    if (locationInView.y < 240.f && locationInView.y > 0.f) {
        [self hiddenTableView];
    }
}


- (FoodTableView *)tableView {
    if (!_tableView) {
        _tableView = [[FoodTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(240, 0, 0, 0);
        
//        UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        imageView.image = [UIImage imageNamed:@"screen"];
//        [backView addSubview:imageView];
//        _tableView.backgroundView = backView;

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.touchDelegate = self;
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = [[UIView alloc] initWithFrame:_tableView.bounds];
        ;
        
        UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, _tableView.frame.size.width, 240.f)];
        clearView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTableView)];
        [clearView addGestureRecognizer:tapGes];
        [_tableView.backgroundView addSubview:clearView];
    }
    
    return _tableView;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        CGFloat H = 44.f;
        CGFloat Y = self.view.frame.size.height - H;
        CGFloat W = self.view.frame.size.width;
        _bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, Y, W, H)];
        _bottomButton.backgroundColor = [UIColor blueColor];
        [_bottomButton addTarget:self action:@selector(resumeTableView) forControlEvents:UIControlEventTouchUpInside];
        [_bottomButton setTitle:@"你最牛逼" forState:UIControlStateNormal];
    }
    return _bottomButton;
}

@end
