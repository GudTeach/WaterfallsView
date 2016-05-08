//
//  WaterfallsViewCell.h
//  瀑布流
//
//  Created by penglang on 16/4/29.
//  Copyright © 2016年 penglang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterfallsViewCell : UIView

@property (nonatomic,copy, readonly) NSString *reuseIdentifier;

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
