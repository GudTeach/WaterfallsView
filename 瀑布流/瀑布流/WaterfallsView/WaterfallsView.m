//
//  WaterfallsView.m
//  瀑布流
//
//  Created by penglang on 16/4/29.
//  Copyright © 2016年 penglang. All rights reserved.
//

#import "WaterfallsView.h"
#import "WaterfallsViewCell.h"

#define WaterfallsViewDefaultMargin 8
#define WaterfallsViewDefaultColumnCount 3
#define WaterfallsViewDefaultCellHeight 100

static CGFloat lastContentOffsetY = 0;


typedef enum{
    
    WaterfallsViewScrollDirectionForward,
    WaterfallsViewScrollDirectionRollback
    
}WaterfallsViewScrollDirection;

@interface WaterfallsView ()

@property (nonatomic, strong) NSMutableArray *cellFrames;

@property (nonatomic, strong) NSMutableDictionary *displayingCells;

@property (nonatomic, strong) NSMutableSet *reusableCells;

@property (nonatomic, assign) WaterfallsViewScrollDirection scrollDirection;

@end


@implementation WaterfallsView

-(WaterfallsViewScrollDirection)scrollDirection{
    
    if (self.contentOffset.y < lastContentOffsetY) return WaterfallsViewScrollDirectionRollback;
    return WaterfallsViewScrollDirectionForward;
}


-(NSMutableSet *)reusableCells{
    if (_reusableCells == nil) {
        _reusableCells = [NSMutableSet  set];
    }
    return _reusableCells;
}

-(NSMutableDictionary *)displayingCells{
    if (_displayingCells == nil) {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

-(NSMutableArray *)cellFrames{
    if (_cellFrames == nil) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

-(void)reloadData{
    [self.cellFrames removeAllObjects];
    [self.displayingCells removeAllObjects];
    
    CGFloat topM = [self marginForType:WaterfallsViewMarginTypeTop];
    CGFloat leftM = [self marginForType:WaterfallsViewMarginTypeLeft];
    CGFloat bottomM = [self marginForType:WaterfallsViewMarginTypeBottom];
    CGFloat rowM = [self marginForType:WaterfallsViewMarginTypeRow];
    CGFloat columnM = [self marginForType:WaterfallsViewMarginTypeColumn];
    
    NSUInteger totalCellCount = [self.dataSource numberOfCells];
    NSUInteger totalColumnCount = [self columnsCount];
    CGFloat cellW = [self cellWidth];
    
    //这个数组用来存放每一列的最大的高度
    CGFloat maxYOfColumn[totalColumnCount];
    for (int i = 0; i < totalColumnCount; i++) {
        maxYOfColumn[i] = 0;
    }
    int cellColumn;
    
    for (int i = 0; i < totalCellCount; i++) {
        
        CGFloat cellH = [self cellHeightAtIndex:i];
        cellColumn = 0;
        for (int j = 1; j < totalColumnCount; j++) {
            if (maxYOfColumn[j] < maxYOfColumn[cellColumn]) {
                cellColumn = j;
            }
        }
        
        CGFloat cellX = leftM + (cellW + columnM) * cellColumn;
        CGFloat cellY;
        
        if (maxYOfColumn[cellColumn] == 0) {
            cellY = topM;
        }else{
            cellY = maxYOfColumn[cellColumn] + rowM;
        }
        
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        maxYOfColumn[cellColumn] = CGRectGetMaxY(cellFrame);
    }
    CGFloat maxYOfWaterfallsView = 0;
    for (int i = 0; i < totalColumnCount; i++) {
        if (maxYOfColumn[i] > maxYOfWaterfallsView) maxYOfWaterfallsView = maxYOfColumn[i];
    }
    maxYOfWaterfallsView += bottomM;
    self.contentSize = CGSizeMake(0, maxYOfWaterfallsView);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //回滚,从后往前遍历cell
    if (self.scrollDirection == WaterfallsViewScrollDirectionRollback) {
        for (int i = (int)[self.dataSource numberOfCells] - 1; i >=0 ; i--) {
            [self handleCellWithIndex:i];
        }
    }else{ //往前滑动更多的cell,一般情况,从前往后遍历cell
        for (int i = 0; i < [self.dataSource numberOfCells]; i++) {
            [self handleCellWithIndex:i];
        }
    }
    lastContentOffsetY = self.contentOffset.y;
    
    
    NSLog(@"displaying Cells Count :%lu",(unsigned long)self.displayingCells.count);
}

-(void)handleCellWithIndex:(NSUInteger)index{
    
    CGRect cellFrame = [self.cellFrames[index] CGRectValue];
    WaterfallsViewCell *cell = self.displayingCells[@(index)];
    if ([self isOnScreen:cellFrame] == YES) {
        
        if (cell == nil) {
            cell = [self.dataSource waterfallsView:self cellAtIndex:index];
            cell.frame = cellFrame;
            self.displayingCells[@(index)] = cell;
            [self addSubview:cell];
        }
    }else{
        if (cell != nil) {
            [self.displayingCells removeObjectForKey:@(index)];
            [cell removeFromSuperview];
            [self.reusableCells addObject:cell];
        }
    }
    
}

/**
 *  供外界调用取可重复利用cell
 */
-(WaterfallsViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    __block WaterfallsViewCell *cell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(WaterfallsViewCell *reusableCell, BOOL *stop) {
        
        if ([reusableCell.reuseIdentifier isEqualToString:identifier]) {
            cell = reusableCell;
            *stop = YES;
        }
        
    }];
    if (cell != nil) {
        [self.reusableCells removeObject:cell];
        
    }
//    NSLog(@"缓存池剩余的cell个数:%ld",self.reusableCells.count);
    return cell;
}

-(CGFloat)cellWidth{
    
    CGFloat leftM = [self marginForType:WaterfallsViewMarginTypeLeft];
    CGFloat rightM = [self marginForType:WaterfallsViewMarginTypeRight];
    CGFloat columnM = [self marginForType:WaterfallsViewMarginTypeColumn];
    
    NSUInteger totalColumnCount = [self columnsCount];
    CGFloat cellW = (self.frame.size.width - leftM - rightM - (totalColumnCount - 1)*columnM )/totalColumnCount;
    return cellW;
}


#pragma mark - 私有方法

-(BOOL)isOnScreen:(CGRect)cellFrame{
    
    if (CGRectGetMaxY(cellFrame) <= self.contentOffset.y) return NO;
    if (cellFrame.origin.y >= self.contentOffset.y + self.frame.size.height) return NO;
    return YES;
    
    
}

-(CGFloat)marginForType:(WaterfallsViewMarginType)type{
    
    CGFloat margin = 0;
    if ([self.delegate respondsToSelector:@selector(waterfallsView:margins:)]) {
        
        margin = [self.delegate waterfallsView:self margins:type];
    }else{
        margin = WaterfallsViewDefaultMargin;
    }
    return margin;
}

-(NSUInteger)columnsCount{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumns)]) return [self.dataSource numberOfColumns];
    return WaterfallsViewDefaultColumnCount;
    
}

-(CGFloat)cellHeightAtIndex:(NSUInteger)index{
    
    if ([self.delegate respondsToSelector:@selector(waterfallsView:heightAtIndex:)]) return [self.delegate waterfallsView:self heightAtIndex:index];
    return WaterfallsViewDefaultCellHeight;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint pointInView = [touch locationInView:self];
    __block NSInteger selectedIndex = -1;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(NSNumber *index, WaterfallsViewCell *cell, BOOL * stop) {
        if (CGRectContainsPoint(cell.frame, pointInView) == YES) {
            selectedIndex = [index unsignedIntegerValue];
            *stop = YES;
        }
    }];
    if (selectedIndex >= 0) {
        if ([self.delegate respondsToSelector:@selector(waterfallsView:didSelectCellAtIndex:)]) {
            [self.delegate waterfallsView:self didSelectCellAtIndex:selectedIndex];
        }
    }
}



@end
