//
//  TmfCalendarViewCell.m
//  Daxiami
//
//  Created by 田明甫 on 2017/7/4.
//  Copyright © 2017年 大虾咪. All rights reserved.
//

#import "TmfCalendarViewCell.h"

@implementation TmfCalendarViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _calendarLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.width)];
        //    calendarLabel.backgroundColor = [UIColor blueColor];
        _calendarLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_calendarLabel];

        
        _contextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.width, self.bounds.size.width,self.bounds.size.height-self.bounds.size.width)];
        _contextLabel.font = [UIFont systemFontOfSize:10];
        _contextLabel.numberOfLines = 0;
        _contextLabel.textAlignment = NSTextAlignmentCenter;
        _contextLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_contextLabel];

    }
    return self;
}

@end
