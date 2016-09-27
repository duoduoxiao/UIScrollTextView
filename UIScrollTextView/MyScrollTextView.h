//
//  MyScrollTextView.h
//  TestLabelScroll
//
//  Created by 钱伟龙 on 16/9/1.
//  Copyright © 2016年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MyTextScrollMode){
    MyTextScrollContinuous,     //连续的滚动
    MyTextScrollSpace,          //间隔的滚动
    MyTextScrollRound           //往复的滚动
};


typedef NS_ENUM(NSInteger,MyTextScrollDirection){
    MyTextScrollMoveLeft,       //向左滚动   
    MyTextScrollMoveRight       //向右滚动
};


@interface MyScrollTextView : UIView

//滚动类型
@property (nonatomic) MyTextScrollMode textScrollMode;
//滚动方向
@property (nonatomic) MyTextScrollDirection textScrollDirection;
//字体颜色
@property (nonatomic,strong) UIColor * textColor;
//文字内容
@property (nonatomic,strong) NSString * text;
//字体大小
@property (nonatomic,strong) UIFont * textFont;
//滚动速度 不设置就默认
@property (nonatomic)CGFloat speed;
//连续滚动时两段之间间隔大小
@property (nonatomic)CGFloat disance;

//开始滚动
- (void)startScroll;
@end
