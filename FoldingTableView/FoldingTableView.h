//
//  FoldingTableView.h
//  FoldingTablView
//
//  Created by YXT on 2016/11/28.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldingSectionHeader.h"

@protocol FoldingTableViewDelegate;
@protocol FoldingTableViewDataSource;

@interface FoldingTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<FoldingTableViewDelegate>foldingTableViewDelegate;

@property (nonatomic, weak) id<FoldingTableViewDataSource>foldingTableViewDataSource;

@end

@protocol FoldingTableViewDelegate <NSObject>

@required

/** 箭头位置 */
- (FoldingSectionHeaderArrowPosition)perferedArrowPositionForFoldingTableView:(FoldingTableView *)foldingTableView;

/** header 的高度 */
- (CGFloat)foldingTableView:(FoldingTableView *)foldingTableView  heightForHeaderInSection:(NSInteger)section;

/** cell 的高度 */
- (CGFloat)foldingTableView:(FoldingTableView *)foldingTableView heightForRowAtIndexPath:(NSIndexPath *)indexpath;

/** 点击 Cell */
- (void)foldingTableView:(FoldingTableView *)foldingTableView didSelectedRowAtIndexpath:(NSIndexPath *)indexPath;

@optional

/** 箭头图片 */
- (UIImage *)foldingTableView:(FoldingTableView *)foldingTableView arrowImageForSection:(NSInteger)section;

- (UIColor *)foldingTableView:(FoldingTableView *)foldingTableView backgroundColorForHeaderInSection:(NSInteger)section;

- (UIFont *)foldingTableView:(FoldingTableView *)foldingTableView fontForTitleInSection:(NSInteger )section;

- (UIFont *)foldingTableView:(FoldingTableView *)foldingTableView fontForDescriptionInSection:(NSInteger )section;

- (UIColor *)foldingTableView:(FoldingTableView *)foldingTableView textColorForTitleInSection:(NSInteger )section;

- (UIColor *)foldingTableView:(FoldingTableView *)foldingTableView textColorForDescriptionInSection:(NSInteger )section;


@end

@protocol FoldingTableViewDataSource <NSObject>

@required
/** Section 的个数 */
- (NSInteger)numberOfSectionForFoldingTableView:(FoldingTableView *)foldingTableView;

/** Cell 的个数 */
-  (NSInteger)foldingTableView:(FoldingTableView *)foldingTableView numberOfRowsInSection:(NSInteger)section;

/** header 的标题 */
- (NSString *)foldingTableView:(FoldingTableView *)foldingTableView  titleForHeaderInSection:(NSInteger)section;

/** 返回 Cell */
- (UITableViewCell *)foldingTableView:(FoldingTableView *)foldingTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
/** 下面设置一些属性 */
- (NSString *)foldingTableView:(FoldingTableView *)foldingTableView decriptionForHeaderInSection:(NSInteger)section;

@end
