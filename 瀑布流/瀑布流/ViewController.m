//
//  ViewController.m
//  瀑布流
//
//  Created by penglang on 16/4/29.
//  Copyright © 2016年 penglang. All rights reserved.
//

#import "ViewController.h"
#import "WaterfallsView.h"
#import "WaterfallsViewCell.h"


#define MyColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define MyColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]


@interface ViewController ()<WaterfallsViewDataSource,WaterfallsViewDelegate>

@property (nonatomic, weak) WaterfallsView *waterfallsView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化瀑布流
    WaterfallsView *waterfallsView = [[WaterfallsView alloc] initWithFrame:self.view.bounds];
    waterfallsView.dataSource = self;
    waterfallsView.delegate = self;
    [self.view addSubview:waterfallsView];
    _waterfallsView = waterfallsView;
    
}

#pragma mark - WaterfallsViewDataSource 数据源方法实现
-(NSUInteger)numberOfCells{
    
    return 1000;
}

-(NSUInteger)numberOfColumns{
    
    return 3;
}

-(WaterfallsViewCell *)waterfallsView:(WaterfallsView *)waterfallsView cellAtIndex:(NSUInteger)index{
    
    static NSString *ID = @"waterfallsCell";
    WaterfallsViewCell *cell = [waterfallsView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[WaterfallsViewCell alloc] initWithReuseIdentifier:ID];
        cell.backgroundColor = MyColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        label.textColor = [UIColor whiteColor];
        label.tag = 10;
        [cell addSubview:label];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%lu",(unsigned long)index];
    
    return cell;
}

#pragma mark - WaterfallsViewDelegate 代理方法实现

-(CGFloat)waterfallsView:(WaterfallsView *)waterfallsView heightAtIndex:(NSUInteger)index{
    
    switch (index%3) {
        case 0:
            return 70.0;
            break;
            
        case 1:
            return 90.0;
            break;
            
        case 2:
            return 120.0;
            break;
            
        default:
            return 150.0;
            break;
    }
    
}

-(CGFloat)waterfallsView:(WaterfallsView *)waterfallsView margins:(WaterfallsViewMarginType)marginType{
    
    switch (marginType) {
        case WaterfallsViewMarginTypeTop:
            return 30;
        case WaterfallsViewMarginTypeLeft:
        case WaterfallsViewMarginTypeBottom:
        case WaterfallsViewMarginTypeRight:
            return 10;
            break;
            
        default:
            return 5;
            break;
    }
    
}

-(void)waterfallsView:(WaterfallsView *)waterfallsView didSelectCellAtIndex:(NSUInteger)index{
    
    NSLog(@"点击了第%lu个cell",(unsigned long)index);
    
}


@end
