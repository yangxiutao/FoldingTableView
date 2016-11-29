//
//  FoldingSectionHeader.h
//  FoldingTablView
//
//  Created by YXT on 2016/11/28.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import <UIKit/UIKit.h>

//Cell  折叠 or 展开
typedef NS_ENUM(NSInteger, FoldingSectionStatus) {
    FoldingSectionFoldState,    //折叠
    FoldingSectionUnfoldState,    //展开
};

//Arrow Position
typedef NS_ENUM(NSInteger, FoldingSectionHeaderArrowPosition) {
    FoldingSectionHeaderArrowPositionLeft,
    FoldingSectionHeaderArrowPositionRight,
};

@protocol FoldingSectionHeaderDelegate <NSObject>

- (void)foldingSectionHeaderTappedAtIndex:(NSInteger)index;

@end

@interface FoldingSectionHeader : UIView

@property (nonatomic, weak) id<FoldingSectionHeaderDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withTag:(NSInteger)tag;

- (void)setupWithBackgroundColor:(UIColor *)backgroundColor
                     titleString:(NSString *)titleString
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                     descriptionString:(NSString *)descriptionString
                      descriptionColor:(UIColor *)descriptionColor
                       descriptionFont:(UIFont *)descriptionFont
                      arrowImage:(UIImage *)arrowImage
                   arrowPosition:(FoldingSectionHeaderArrowPosition)arrowPosition
                    sectionState:(FoldingSectionStatus)sectionState;


@end
