//
//  WaterfallsViewCell.m
//  瀑布流
//
//  Created by penglang on 16/4/29.
//  Copyright © 2016年 penglang. All rights reserved.
//

#import "WaterfallsViewCell.h"

static NSUInteger count = 0;

@interface WaterfallsViewCell ()

@property (nonatomic,copy, readwrite) NSString *reuseIdentifier;

@end

@implementation WaterfallsViewCell


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super init]) {
        self.reuseIdentifier = reuseIdentifier;
    }
    NSLog(@"创建cell%lu",(unsigned long)++count);
    return self;
}

@end
