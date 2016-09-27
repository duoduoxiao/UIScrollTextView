//
//  MyScrollTextView.m
//  TestLabelScroll
//
//  Created by 钱伟龙 on 16/9/1.
//  Copyright © 2016年 duoduo. All rights reserved.
//

#import "MyScrollTextView.h"

#define LabelDistance   30.f

@implementation MyScrollTextView
{
    UILabel * _contentLabel1;
    UILabel * _contentLabel2;
    
    CGFloat _textWidth;
    NSTimer * _timer;
    int _offset;
}

@synthesize textColor = _textColor;

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initText];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initText];
    }
    return self;
}

- (void)_initText
{
    self.clipsToBounds = YES;
    self.speed = 0.03;
    self.textFont = [UIFont systemFontOfSize:15.f];
    _offset = -1;
}

- (void)setTextScrollMode:(MyTextScrollMode)textScrollMode
{
    if (_textScrollMode != textScrollMode) {
        _textScrollMode = textScrollMode;
        [self setNeedsLayout];
    }
}

- (void)setTextScrollDirection:(MyTextScrollDirection)textScrollDirection
{
    if (_textScrollDirection != textScrollDirection) {
        _textScrollDirection = textScrollDirection;
        [self setNeedsLayout];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (_textColor != textColor) {
        _textColor = textColor;
        [self setNeedsLayout];
    }
}

- (void)setText:(NSString *)text
{
    if (![_text isEqualToString:text]) {
        _text = text;
        [self setNeedsLayout];
    }
}

- (void)setTextFont:(UIFont *)textFont
{
    if (_textFont != textFont) {
        _textFont = textFont;
        [self setNeedsLayout];
    }
}

- (UIColor *)textColor
{
    return _textColor ?: [UIColor blackColor];
}

-(void)setSpeed:(CGFloat)speed
{
    if (_speed != speed) {
        _speed = speed;
        [self setNeedsLayout];
    }
}

#pragma mark - 

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _updateScrollTextView];
    
}

- (void)_updateScrollTextView
{
    for (int i = 0; i < self.subviews.count; i++) {
        UIView * view = [self.subviews objectAtIndex:i];
        [view removeFromSuperview];
        view = nil;
    }
    
    
    _textWidth = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.textFont,NSFontAttributeName, nil]].width;
    [self creatScroll];
}

- (void)creatScroll
{
    if (self.text.length == 0) {
        return;
    }
    
    switch (self.textScrollMode) {
        case MyTextScrollContinuous:
        {
            if (_textWidth > self.frame.size.width) {
                if (self.textScrollDirection == MyTextScrollMoveLeft) {
                    [self creatLabel1AndLabel2WithFrame1:CGRectMake(0, 0, _textWidth, self.frame.size.height) frame2:CGRectMake(_textWidth + LabelDistance, 0, _textWidth, self.frame.size.height)];
                }else{
                    [self creatLabel1AndLabel2WithFrame1:CGRectMake(self.frame.size.width - _textWidth, 0, _textWidth, self.frame.size.height) frame2:CGRectMake(self.frame.size.width - 2 * _textWidth - LabelDistance, 0, _textWidth, self.frame.size.height)];
                }
            }else{
                if (self.textScrollDirection == MyTextScrollMoveLeft) {
                    [self creatLabel1WithFrame:CGRectMake(0, 0, _textWidth, self.frame.size.height)];
                }else{
                    [self creatLabel1WithFrame:CGRectMake(self.frame.size.width - _textWidth, 0, _textWidth, self.frame.size.height)];
                }
            }
        }
            break;
        
        case MyTextScrollSpace:
        {
            if (_textWidth < self.frame.size.width) {
                [self creatLabel1WithFrame:CGRectMake(0, 0, _textWidth, self.frame.size.height)];
            }else{
                if (self.textScrollDirection == MyTextScrollMoveLeft) {
                    [self creatLabel1WithFrame:CGRectMake(self.frame.size.width, 0, _textWidth, self.frame.size.height)];
                }else{
                    [self creatLabel1WithFrame:CGRectMake(_textWidth, 0, _textWidth, self.frame.size.height)];
                }
            }
        }
            break;
            
        case MyTextScrollRound:
        {
            [self creatLabel1WithFrame:CGRectMake(0, 0, _textWidth, self.frame.size.height)];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 

- (void)creatLabel1WithFrame:(CGRect)frame
{
    _contentLabel1 = [[UILabel alloc] initWithFrame:frame];
    _contentLabel1.text = self.text;
    _contentLabel1.font = self.textFont;
    _contentLabel1.textColor = self.textColor;
    _contentLabel1.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel1];
}

- (void)creatLabel1AndLabel2WithFrame1:(CGRect)frame1 frame2:(CGRect)frame2
{
    _contentLabel1 = [[UILabel alloc] initWithFrame:frame1];
    _contentLabel1.text = self.text;
    _contentLabel1.font = self.textFont;
    _contentLabel1.textColor = self.textColor;
    _contentLabel1.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel1];
    
    _contentLabel2 = [[UILabel alloc] initWithFrame:frame2];
    _contentLabel2.text = self.text;
    _contentLabel2.font = self.textFont;
    _contentLabel2.textColor = self.textColor;
    _contentLabel2.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel2];
}

#pragma mark - 

- (void)startScroll
{
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.speed target:self selector:@selector(contentMove) userInfo:nil repeats:YES];
}

#pragma mark -

- (void)contentMove
{
    if (_textWidth < self.frame.size.width) {
        if (self.textScrollMode == MyTextScrollSpace) {
//            [self moveRound];
//            [self moveContinuous];
        }
        return;
    }
    switch (self.textScrollMode) {
        case MyTextScrollContinuous:
            [self moveContinuous];
            break;
            
        case MyTextScrollSpace:
            [self moveSpace];
            break;
            
        case MyTextScrollRound:
            [self moveRound];
            break;
            
        default:
            break;
    }
    
}


- (void)moveContinuous
{
    if (self.textScrollDirection == MyTextScrollMoveLeft) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x - 1, 0, _textWidth, self.frame.size.height);
        _contentLabel2.frame = CGRectMake(_contentLabel2.frame.origin.x - 1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x < -_textWidth - LabelDistance) {
            _contentLabel1.frame = CGRectMake(_contentLabel2.frame.origin.x + _textWidth + LabelDistance, 0, _textWidth, self.frame.size.height);
        }
        if (_contentLabel2.frame.origin.x < -_textWidth - LabelDistance) {
            _contentLabel2.frame = CGRectMake(_contentLabel1.frame.origin.x + _textWidth + LabelDistance, 0, _textWidth, self.frame.size.height);
        }
        
    }else{
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x + 1, 0, _textWidth, self.frame.size.height);
        _contentLabel2.frame = CGRectMake(_contentLabel2.frame.origin.x + 1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x > _textWidth + LabelDistance) {
            _contentLabel1.frame = CGRectMake(_contentLabel2.frame.origin.x - _textWidth - LabelDistance, 0, _textWidth, self.frame.size.height);
        }
        if (_contentLabel2.frame.origin.x > _textWidth + LabelDistance) {
            _contentLabel2.frame = CGRectMake(_contentLabel1.frame.origin.x - _textWidth - LabelDistance, 0, _textWidth, self.frame.size.height);
        }
    }
}

- (void)moveSpace
{
    if (self.textScrollDirection == MyTextScrollMoveLeft) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x - 1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x < -_textWidth) {
            _contentLabel1.frame = CGRectMake(self.frame.size.width, 0, _textWidth, self.frame.size.height);
        }
    }else{
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x + 1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x > self.frame.size.width) {
            _contentLabel1.frame = CGRectMake(-_textWidth, 0, _textWidth, self.frame.size.height);
        }
    }
}

- (void)moveRound
{
    _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x + _offset, 0, _textWidth, self.frame.size.height);
    if (_contentLabel1.frame.origin.x < self.frame.size.width - _textWidth) {
        _offset = 1;
    }
    if (_contentLabel1.frame.origin.x > 2) {
        _offset = -1;
    }
}







@end
