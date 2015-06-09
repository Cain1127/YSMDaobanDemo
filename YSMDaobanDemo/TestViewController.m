//
//  TestViewController.m
//  YSMDaobanDemo
//
//  Created by ysmeng on 15/6/8.
//  Copyright (c) 2015年 杨声孟个人开发. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *weaponButton;            //!<滚动栏:第一个按钮
@property (weak, nonatomic) IBOutlet UIButton *westButton;              //!<滚动栏:第二个按钮
@property (weak, nonatomic) IBOutlet UIButton *whoButton;               //!<滚动栏:第三个按钮

@property (weak, nonatomic) IBOutlet UIButton *nWeaponButton;           //!<导航栏：第一个按钮
@property (weak, nonatomic) IBOutlet UIButton *nWestButton;             //!<导航栏：第二个按钮
@property (weak, nonatomic) IBOutlet UIButton *nWhoButton;              //!<导航栏：第三个按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxHeight;     //!<按钮的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;  //!<按钮的原始大小

@property (assign, nonatomic) BOOL isNavigationStatus;                  //!<当前是否是处于导航栏

@end

@implementation TestViewController

#pragma mark -
#pragma mark - UI加载
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    /**
     *  扩展：这里可以使用RAC库来观察scrollView的偏移变化，
     *       也可以参考MJ哥的头部刷新做观察者监听
     */
    
}

#pragma mark -
#pragma mark - 滚动设置
///滚动时判断滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    ///初始时为0.0f
    static CGFloat starYPoint = 0.0f;
    
    /*
     *  判断滚动方向
     *
     *  当前的偏移比原来的大，则表示向下滚动
     *  当前的偏移比原来的小，则表示向上滚动
     *
     *  每次判断完成后更新starYPoint
     *
     */
    
    ///向下滚动
    if (scrollView.contentOffset.y - starYPoint > 0.05f) {
        
        ///重要：重置记录的坐标
        starYPoint = scrollView.contentOffset.y;
        
        /**
         *
         *  通过当前的偏移量，改变button的位置
         *
         *  设置最高目标位置
         *
         */
        
        ///如果当前已处于导航栏，则不再动画
        if (self.isNavigationStatus) {
            
            return;
            
        }
        
        ///判断当前偏移量：超过动画需求监听量，则将按钮移到导航栏中
        if (starYPoint >= self.maxHeight.constant - 10.0f) {
            
            ///锁定状态
            self.isNavigationStatus = YES;
            
            ///隐藏滚动体按钮
            self.weaponButton.alpha = 0.0f;
            self.westButton.alpha = 0.0f;
            self.whoButton.alpha = 0.0f;
            
            self.nWeaponButton.alpha = 0.1f;
            self.nWestButton.alpha = 0.1f;
            self.nWhoButton.alpha = 0.1f;
            
            ///初始化在指定位置
            self.nWeaponButton.center = CGPointMake(10.0f + 22.0f + 30.0f, 22.0f + 10.0f);
            self.nWestButton.center = CGPointMake(57.0f + 22.0f + 30.0f, 22.0f + 10.0f);
            self.nWhoButton.center = CGPointMake(104.0f + 22.0f + 30.0f, 22.0f + 10.0f);
            
            ///移动
            [UIView animateWithDuration:0.3f animations:^{
                
                ///透明度
                self.nWeaponButton.alpha = 1.0f;
                self.nWestButton.alpha = 1.0f;
                self.nWhoButton.alpha = 1.0f;
                
                ///位置
                self.nWeaponButton.center = CGPointMake(10.0f + 22.0f, 22.0f);
                self.nWestButton.center = CGPointMake(57.0f + 22.0f, 22.0f);
                self.nWhoButton.center = CGPointMake(104.0f + 22.0f, 22.0f);
                
            }];
            
            return;
            
        }
        
        ///计算大小的量变：由于向下滚动时，需要变小，故用最大值减当前值
        CGFloat change = (self.maxHeight.constant - starYPoint) / self.maxHeight.constant;
        
        ///保证最小
        CGFloat width = self.buttonHeight.constant / 4.0f + self.buttonHeight.constant * 3.0f / 4.0f * change;
        width = self.buttonHeight.constant < width ? self.buttonHeight.constant : width;
        
        ///重置大小
        self.weaponButton.bounds = CGRectMake(0.0f, 0.0f, width, width);
        self.westButton.bounds = CGRectMake(0.0f, 0.0f, width, width);
        self.whoButton.bounds = CGRectMake(0.0f, 0.0f, width, width);
        
        ///透明度:可以调整数值达到指定效果
        self.weaponButton.alpha = change > 1.0f ? 1.0f : (change < 0.0f ? 0.0f : change);
        self.westButton.alpha = change > 1.0f ? 1.0f : (change < 0.0f ? 0.0f : change);
        self.whoButton.alpha = change > 1.0f ? 1.0f : (change < 0.0f ? 0.0f : change);
        
        //TODO:位置量变，一般是让按钮靠近
        
        return;
        
    }
    
    ///向上滚动
    if (scrollView.contentOffset.y - starYPoint < -0.05f) {
        
        ///重要：重置记录的坐标
        starYPoint = scrollView.contentOffset.y;
        
        ///如果当前处于非导航栏并且已是最大大小，则不再动画
        if (!self.isNavigationStatus &&
            self.weaponButton.bounds.size.width >= self.buttonHeight.constant) {
            
            return;
            
        }
        
        ///判断当前偏移量：超过动画需求监听量，则无动作
        if (starYPoint <= 0.0f) {
            
            return;
            
        }
        
        ///偏移达指定量时，则移除导航栏按钮
        if (starYPoint <= 240.0f &&
            self.isNavigationStatus) {
            
            [UIView animateWithDuration:0.3f animations:^{
                
                ///透明度调整
                self.nWeaponButton.alpha = 0.1f;
                self.nWestButton.alpha = 0.1f;
                self.nWhoButton.alpha = 0.1f;
                
                ///位置
                self.nWeaponButton.center = CGPointMake(10.0f + 22.0f + 30.0f, 22.0f + 10.0f);
                self.nWestButton.center = CGPointMake(57.0f + 22.0f + 30.0f, 22.0f + 10.0f);
                self.nWhoButton.center = CGPointMake(104.0f + 22.0f + 30.0f, 22.0f + 10.0f);
                
            } completion:^(BOOL finished) {
                
                ///恢复状态
                self.isNavigationStatus = NO;
                
                ///清空原指针
                self.nWeaponButton.alpha = 0.0f;
                self.nWestButton.alpha = 0.0f;
                self.nWhoButton.alpha = 0.0f;
                
                self.weaponButton.alpha = 0.1f;
                self.westButton.alpha = 0.1f;
                self.whoButton.alpha = 0.1f;
                
            }];
            
        }
        
        ///计算大小的量变：由于向下滚动时，需要变小，故用最大值减当前值
        CGFloat change = (self.maxHeight.constant - starYPoint) / self.maxHeight.constant;
        
        ///计算大小的量变
        CGFloat width = self.buttonHeight.constant / 4.0f + self.buttonHeight.constant * 3.0f / 4.0f * change;
        width = self.buttonHeight.constant < width ? self.buttonHeight.constant : width;
        
        ///重置大小
        self.weaponButton.bounds = CGRectMake(0.0f, 0.0f, width, width);
        self.westButton.bounds = CGRectMake(0.0f, 0.0f, width, width);
        self.whoButton.bounds = CGRectMake(0.0f, 0.0f, width, width);
        
        ///透明度:可以调整数值达到指定效果
        self.weaponButton.alpha = change > 1.0f ? 1.0f : (change < 0.0f ? 0.0f : change);
        self.westButton.alpha = change > 1.0f ? 1.0f : (change < 0.0f ? 0.0f : change);
        self.whoButton.alpha = change > 1.0f ? 1.0f : (change < 0.0f ? 0.0f : change);
        
        //TODO:位置量变,一般是让按钮位置分离
        
        return;
        
    }

}

#pragma mark -
#pragma mark - 按钮事件
- (IBAction)weaponButtonAction:(UIButton *)sender
{
    
    NSLog(@"按钮点击日志:第一个按钮");
    
}

- (IBAction)westButtonAction:(UIButton *)sender
{
    
    NSLog(@"按钮点击日志:第二个按钮");
    
}

- (IBAction)whoButtonAction:(UIButton *)sender
{
    
    NSLog(@"按钮点击日志:第三个按钮");
    
}

@end
