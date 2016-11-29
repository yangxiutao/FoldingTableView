//
//  FoldingSectionHeader.m
//  FoldingTablView
//
//  Created by YXT on 2016/11/28.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import "FoldingSectionHeader.h"

static CGFloat foldingSeperatorLineWidth = 0.3f;

static CGFloat foldingMargin = 8.0f;

static CGFloat foldingIconSize = 24.0f;

@interface FoldingSectionHeader ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) CAShapeLayer *seperatorLine;

@property (nonatomic, assign) FoldingSectionHeaderArrowPosition arrowPosition;

@property (nonatomic, assign) FoldingSectionStatus sectionState;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;


@end

@implementation FoldingSectionHeader


#pragma mark - Lazy Initial SubViews

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel{
    
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textAlignment = NSTextAlignmentRight;
    }
    return _descriptionLabel;
}

- (UIImageView *)arrowImageView{
    
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _arrowImageView.backgroundColor = [UIColor clearColor];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}

- (CAShapeLayer *)seperatorLine{
    
    if (!_seperatorLine) {
        _seperatorLine = [CAShapeLayer layer];
        _seperatorLine.strokeColor = [UIColor whiteColor].CGColor;
        _seperatorLine.lineWidth = foldingSeperatorLineWidth;
    }
    return _seperatorLine;
}


- (UITapGestureRecognizer *)tapGesture{
    
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapped:)];
    }
    return _tapGesture;
}


#pragma mark - Initial Method

- (void)awakeFromNib{
    [super awakeFromNib];
     [self setupSubViewsWithArrowPosition:FoldingSectionHeaderArrowPositionLeft];
}

- (instancetype)initWithFrame:(CGRect)frame withTag:(NSInteger)tag{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.tag = tag;
        [self setupSubViewsWithArrowPosition:FoldingSectionHeaderArrowPositionLeft];
    }
    return self;
}

- (void)setupSubViewsWithArrowPosition:(FoldingSectionHeaderArrowPosition)arrowPosition{
    
    CGFloat labelWith = (self.frame.size.width - foldingMargin * 2 - foldingIconSize)/2;
    CGFloat labelHeight = self.frame.size.height;
    
    CGRect arrowRect = CGRectMake(0, self.frame.size.height /2 - foldingIconSize / 2, foldingIconSize, foldingIconSize);
    
    CGRect titleRect = CGRectMake(foldingMargin + foldingIconSize, 0 , labelWith, labelHeight);
    
    CGRect descriptionRect = CGRectMake(foldingMargin + foldingIconSize + labelWith, 0, labelWith, labelHeight);
    
    if (arrowPosition == FoldingSectionHeaderArrowPositionRight) {
        arrowRect.origin.x = foldingMargin * 2 + labelWith * 2;
        titleRect.origin.x = foldingMargin;
        descriptionRect.origin.x = foldingMargin + labelWith;

    }
    
  
    
    [self.titleLabel setFrame:titleRect];
    [self.descriptionLabel setFrame:descriptionRect];
    [self.arrowImageView setFrame:arrowRect];
    [self.seperatorLine setPath:self.getSepertorPath.CGPath];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.descriptionLabel];
    [self addSubview:self.arrowImageView];
    [self addGestureRecognizer:self.tapGesture];
    [self.layer addSublayer:self.seperatorLine];
    
}

- (UIBezierPath *)getSepertorPath{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.frame.size.height - foldingSeperatorLineWidth)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - foldingSeperatorLineWidth)];
    return path;
}

- (void)setupWithBackgroundColor:(UIColor *)backgroundColor
                     titleString:(NSString *)titleString
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
               descriptionString:(NSString *)descriptionString
                descriptionColor:(UIColor *)descriptionColor
                 descriptionFont:(UIFont *)descriptionFont
                      arrowImage:(UIImage *)arrowImage
                   arrowPosition:(FoldingSectionHeaderArrowPosition)arrowPosition
                    sectionState:(FoldingSectionStatus)sectionState{
    
    self.backgroundColor = backgroundColor;
    
    [self setupSubViewsWithArrowPosition:arrowPosition];
    
    self.titleLabel.text = titleString;
    self.titleLabel.font = titleFont;
    self.titleLabel.textColor = titleColor;
    
    self.descriptionLabel.text = descriptionString;
    self.descriptionLabel.textColor = descriptionColor;
    self.descriptionLabel.font = descriptionFont;
    
    self.arrowImageView.image = arrowImage;
    self.arrowPosition = arrowPosition;
    self.sectionState = sectionState;
    
    switch (sectionState) {
        case FoldingSectionFoldState:
        {
            //折叠
            if (self.arrowPosition == FoldingSectionHeaderArrowPositionRight) {
                _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            }else{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
            }
        }
            break;
        case FoldingSectionUnfoldState:
        {
            //展开
            if (self.arrowPosition == FoldingSectionHeaderArrowPositionRight) {
                self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
            }else{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            }
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - Private Method

- (void)shouldExpand:(BOOL)shouldExpand{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (shouldExpand) {
            
            if (self.arrowPosition == FoldingSectionHeaderArrowPositionRight) {
                self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
            }else{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            }
        }else{
            if (self.arrowPosition == FoldingSectionHeaderArrowPositionRight) {
                self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            }else{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
            }
        }
    }completion:^(BOOL finished) {
        if (finished) {
            self.seperatorLine.hidden = shouldExpand;
        }
    }];
}

- (void)onTapped:(UITapGestureRecognizer *)tap{
    
    [self shouldExpand:![NSNumber numberWithInteger:self.sectionState].boolValue];
    
    if (_delegate || [_delegate respondsToSelector:@selector(foldingSectionHeaderTappedAtIndex:)]) {
        self.sectionState = [NSNumber numberWithBool:(![NSNumber numberWithInteger:self.sectionState].boolValue)].integerValue;
        [_delegate foldingSectionHeaderTappedAtIndex:self.tag];
    }
    
}

@end
