//
//  WaterfallsView.h
//  瀑布流
//
//  Created by penglang on 16/4/29.
//  Copyright © 2016年 penglang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterfallsView,WaterfallsViewCell;

typedef enum {
    
    WaterfallsViewMarginTypeTop,
    WaterfallsViewMarginTypeLeft,
    WaterfallsViewMarginTypeBottom,
    WaterfallsViewMarginTypeRight,
    WaterfallsViewMarginTypeColumn,
    WaterfallsViewMarginTypeRow
    
}WaterfallsViewMarginType;

@protocol WaterfallsViewDataSource <NSObject>

@required
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
 *  有多少个cell
 */
-(NSUInteger)numberOfCells;



/**
 *  在某一个序号的cell
 */
-(WaterfallsViewCell *)waterfallsView:(WaterfallsView *)waterfallsView cellAtIndex:(NSUInteger)index;

@optional
/**
 *  有多少列
 */
-(NSUInteger)numberOfColumns;

@end

@protocol WaterfallsViewDelegate <UIScrollViewDelegate>
@optional

/**
 *  某一个序号的单元格的高度
 */
-(CGFloat)waterfallsView:(WaterfallsView *)waterfallsView heightAtIndex:(NSUInteger)index;

/**
 *  单元格与瀑布流视图的边界
 */

-(CGFloat)waterfallsView:(WaterfallsView *)waterfallsView margins:(WaterfallsViewMarginType)marginType;

-(void)waterfallsView:(WaterfallsView *)waterfallsView didSelectCellAtIndex:(NSUInteger)index;

@end

@interface WaterfallsView : UIScrollView


@property (nonatomic, assign) id<WaterfallsViewDataSource> dataSource;

@property (nonatomic, assign) id<WaterfallsViewDelegate> delegate;

-(void)reloadData;

-(WaterfallsViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

-(CGFloat)cellWidth;


@end

