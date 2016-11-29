//
//  FoldingTableView.m
//  FoldingTablView
//
//  Created by YXT on 2016/11/28.
//  Copyright © 2016年 YXT. All rights reserved.
//

#import "FoldingTableView.h"

@interface FoldingTableView ()<FoldingSectionHeaderDelegate>

@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation FoldingTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDelegateAndDataSource];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDelegateAndDataSource];
    }
    return self;
}

- (void)setupDelegateAndDataSource{
    
    self.delegate = self;
    self.dataSource = self;
    
    if (self.style == UITableViewStylePlain) {
        self.tableFooterView = [[UIView alloc]init];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

- (NSMutableArray *)statusArray{
    
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    
    if (_statusArray.count) {
        
        if (_statusArray.count > self.numberOfSections) {
            [_statusArray removeObjectsInRange:NSMakeRange(self.numberOfSections - 1, _statusArray.count - self.numberOfSections)];
            
        }else{
            if (_statusArray.count < self.numberOfSections) {
                for (NSInteger i = self.numberOfSections - _statusArray.count; i < self.numberOfSections; i ++) {
                    [_statusArray addObject:[NSNumber numberWithInteger:FoldingSectionFoldState]];
                }
            }
        }
        
    }else{
        for (NSInteger i = 0; i < self.numberOfSections; i ++) {
            [_statusArray addObject:[NSNumber numberWithInteger:FoldingSectionFoldState]];
        }
    }
    
    return _statusArray;
}


#pragma mark - UI Configration

- (FoldingSectionHeaderArrowPosition)perferedArrowPosition{
    
    if (_foldingTableViewDelegate && [_foldingTableViewDelegate respondsToSelector:@selector(perferedArrowPositionForFoldingTableView:)]) {
        return [_foldingTableViewDelegate perferedArrowPositionForFoldingTableView:self];
    }
    
    return FoldingSectionHeaderArrowPositionRight;
}

- (UIColor *)backgroundColorForSection:(NSInteger)section{
    
    if (_foldingTableViewDelegate && [_foldingTableViewDelegate respondsToSelector:@selector(foldingTableView:backgroundColorForHeaderInSection:)]) {
        return [_foldingTableViewDelegate foldingTableView:self backgroundColorForHeaderInSection:section];
    }
    return [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
}

- (NSString *)titleForSection:(NSInteger)section{
    if (_foldingTableViewDataSource && [_foldingTableViewDataSource respondsToSelector:@selector(foldingTableView:titleForHeaderInSection:)]) {
       return [_foldingTableViewDataSource foldingTableView:self titleForHeaderInSection:section];
    }
    return [NSString string];
}


- (UIFont *)titleFontForSection:(NSInteger)section{
    if (_foldingTableViewDelegate && [_foldingTableViewDelegate respondsToSelector:@selector(foldingTableView:fontForTitleInSection:)]) {
        return [_foldingTableViewDelegate foldingTableView:self fontForTitleInSection:section];
    }
    return [UIFont systemFontOfSize:16];
}


-(UIColor *)titleColorForSection:(NSInteger )section
{
    if (_foldingTableViewDelegate && [_foldingTableViewDelegate respondsToSelector:@selector(foldingTableView:textColorForTitleInSection:)]) {
        return [_foldingTableViewDelegate foldingTableView:self textColorForTitleInSection:section];
    }
    return [UIColor whiteColor];
}
-(NSString *)descriptionForSection:(NSInteger )section
{
    if (_foldingTableViewDataSource && [_foldingTableViewDataSource respondsToSelector:@selector(foldingTableView:decriptionForHeaderInSection:)]) {
        return [_foldingTableViewDataSource foldingTableView:self decriptionForHeaderInSection:section];
    }
    return [NSString string];
}
-(UIFont *)descriptionFontForSection:(NSInteger )section
{
    if (_foldingTableViewDelegate && [_foldingTableViewDelegate respondsToSelector:@selector(foldingTableView:fontForDescriptionInSection:)]) {
        return [_foldingTableViewDelegate foldingTableView:self fontForDescriptionInSection:section];
    }
    return [UIFont boldSystemFontOfSize:13];
}

-(UIColor *)descriptionColorForSection:(NSInteger )section
{
    if (_foldingTableViewDelegate && [_foldingTableViewDelegate respondsToSelector:@selector(foldingTableView:textColorForDescriptionInSection:)]) {
        return [_foldingTableViewDelegate foldingTableView:self textColorForDescriptionInSection:section];
    }
    return [UIColor whiteColor];
}

-(UIImage *)arrowImageForSection:(NSInteger )section
{
    if (_foldingTableViewDelegate && [_foldingTableViewDelegate respondsToSelector:@selector(foldingTableView:arrowImageForSection:)]) {
        return [_foldingTableViewDelegate foldingTableView:self arrowImageForSection:section];
    }
    return [UIImage imageNamed:@"Arrow"];
}


#pragma mark - UITableView Delegate And DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_foldingTableViewDataSource && [_foldingTableViewDataSource respondsToSelector:@selector(numberOfSectionForFoldingTableView:)]) {
        return [_foldingTableViewDataSource numberOfSectionForFoldingTableView:self];
    }else{
        return self.numberOfSections;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (((NSNumber *)self.statusArray[section]).integerValue == FoldingSectionUnfoldState) {
        if (_foldingTableViewDataSource && [_foldingTableViewDataSource respondsToSelector:@selector(foldingTableView:numberOfRowsInSection:)]) {
            return [_foldingTableViewDataSource foldingTableView:self numberOfRowsInSection:section];
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (_foldingTableViewDelegate && [_foldingTableViewDelegate respondsToSelector:@selector(foldingTableView:heightForHeaderInSection:)]) {
        return [_foldingTableViewDelegate foldingTableView:self heightForHeaderInSection:section];
    }else{
        return self.sectionHeaderHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_foldingTableViewDelegate && [_foldingTableViewDelegate respondsToSelector:@selector(foldingTableView:heightForRowAtIndexPath:)]) {
        return [_foldingTableViewDelegate foldingTableView:self heightForRowAtIndexPath:indexPath];
    }else{
        return self.rowHeight;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.style == UITableViewStylePlain) {
        return 0;
    }else{
        return 0.001;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    FoldingSectionHeader *header = [[FoldingSectionHeader alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [self tableView:self heightForHeaderInSection:section]) withTag:section];
    
    [header setupWithBackgroundColor:[self backgroundColorForSection:section]
                         titleString:[self titleForSection:section]
                          titleColor:[self titleColorForSection:section]
                           titleFont:[self titleFontForSection:section]
                   descriptionString:[self descriptionForSection:section]
                    descriptionColor:[self  descriptionColorForSection:section]
                     descriptionFont:[self descriptionFontForSection:section]
                          arrowImage:[self arrowImageForSection:section]
                       arrowPosition:[self perferedArrowPosition]
                        sectionState:((NSNumber *)self.statusArray[section]).integerValue];
    header.delegate = self;
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_foldingTableViewDataSource && [_foldingTableViewDataSource respondsToSelector:@selector(foldingTableView:cellForRowAtIndexPath:)]) {
        return [_foldingTableViewDataSource foldingTableView:self cellForRowAtIndexPath:indexPath];
    }
    
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCellIndentifier"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_foldingTableViewDelegate && [_foldingTableViewDelegate respondsToSelector:@selector(foldingTableView:didSelectedRowAtIndexpath:)]) {
        [_foldingTableViewDelegate foldingTableView:self didSelectedRowAtIndexpath:indexPath];
    }
}


#pragma mark - FoldingSectionHeader Delegate

- (void)foldingSectionHeaderTappedAtIndex:(NSInteger)index{
    
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index]).boolValue;
    
    [self.statusArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!currentIsOpen]];
    
    NSInteger numberOfRow = [_foldingTableViewDataSource foldingTableView:self numberOfRowsInSection:index];
    
    NSMutableArray *rowArray = [NSMutableArray array];
    
    if (numberOfRow) {
        for (NSInteger i = 0; i < numberOfRow; i++) {
            [rowArray addObject:[NSIndexPath indexPathForRow:i inSection:index]];
        }
    }
    
    if (rowArray.count) {
        if (currentIsOpen) {
            [self deleteRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [self insertRowsAtIndexPaths:[NSArray arrayWithArray:rowArray] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

@end
