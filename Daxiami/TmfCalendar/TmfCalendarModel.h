//
//  TmfCalendarModel.h
//  Daxiami
//
//  Created by 大虾咪 on 2017/7/3.
//  Copyright © 2017年 大虾咪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DateBlock)(NSInteger,NSInteger);
@interface TmfCalendarModel : NSObject


@property(nonatomic, copy) DateBlock dateBlock;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, assign) NSInteger lastMonthIndex;
@property(nonatomic, assign) NSInteger nextMonthIndex;////下个月的index和


//每个日期表 显示的具体天数 从几号开始 到几号 结束
- (NSMutableArray *)getDayArray ;

//上个月的
- (NSMutableArray *)getLastDayArray;

//下个月的
- (NSMutableArray *)getNextDayArray;

@end
