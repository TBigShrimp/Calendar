//
//  TmfCalendarModel.m
//  Daxiami
//
//  Created by 大虾咪 on 2017/7/3.
//  Copyright © 2017年 大虾咪. All rights reserved.
//

#import "TmfCalendarModel.h"

@interface TmfCalendarModel ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, assign) NSInteger day;//天
@property (nonatomic, assign) NSInteger month;//月
@property (nonatomic, assign) NSInteger year;//年
@property (nonatomic, assign) NSInteger weekDay;//周
//每个日期表 显示的具体天数 从几号开始 到几号 结束
@property (nonatomic, strong) NSMutableArray *dayArray;


@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@end


@implementation TmfCalendarModel

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        self.dayArray = [NSMutableArray array];
        //获取当天的年月日
        [self getCurrentDay];
        
        
        //计算每月的天数 (这个月有几天 就传当天的日期)
//        [self totalDaysInMonth:nowDate];
        
        // 计算本月第一天是周几
//        [self currentMonthFirstDayInWeek];
     
        //计算本月最后一天是周
//        [self currentMonthLastDayInWeek];
    
    }
    return self;
}

//上个月的
- (NSMutableArray *)getLastDayArray{
    
    [self.dayArray removeAllObjects];
    if (_month == 1) {
        _month = 12;
        _year --;
    }else {
        _month --;
    }
    
    return [self getDayArray];
    
}

//下个月的
- (NSMutableArray *)getNextDayArray{
    
    [self.dayArray removeAllObjects];

    if (_month == 12) {
        _month = 1;
        _year ++;
    }else {
        _month ++;
    }
    return [self getDayArray];

}

- (void)getCurrentDay {

    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *nowComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    //当年
    self.year = nowComponents.year;
    //当月
    self.month = nowComponents.month;
    //当天
    self.day = nowComponents.day;
    //本周
    self.weekDay = nowComponents.weekday;

}


- (NSMutableArray *)getDayArray {
    
    //返回上个月第一天的NSDate对象
    NSDate *lastDate = [self setLastMonthWithDay];
    NSDateFormatter *dateFm = [[NSDateFormatter alloc] init];
    [dateFm setDateFormat:@"yyyyMM"];
    NSString *lastDateString = [dateFm stringFromDate:lastDate];
    //上个月的天数范围
    NSRange lastdayRange = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:lastDate];

    //计算本月第一天是周几
    NSInteger currentWeekFirstDay = [self currentMonthFirstDayInWeek];
    //上个月遗留的天数
    for (NSInteger i = lastdayRange.length - currentWeekFirstDay + 2; i <= lastdayRange.length; i++) {
        NSString * string = [NSString stringWithFormat:@"%@%ld",lastDateString,i];
        [self.dayArray addObject:string];
    }
    
    NSDate *nowDate = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",_year,_month,_day]];

    NSRange nowDayRange = [self totalDaysInMonth:nowDate];
    
    //本月的总天数
    for (NSInteger i = 1; i <= nowDayRange.length ; i++) {
        NSString * string = [NSString stringWithFormat:@"%ld%02ld%02ld",self.year,self.month,i];
        [self.dayArray addObject:string];
    }
    
    //计算本月最后一天是周几
   NSInteger currentWeekLastDay = [self currentMonthLastDayInWeek];
    
    //下个月空出的天数
    NSInteger lastMonth=0;
    NSInteger lastYear=0;
    if (_month == 1) {
        lastMonth = 12;
        lastYear = _year-1;
    }else {
        lastYear = _year;
        lastMonth = _month+1;
    }
    
    for (NSInteger i = 1; i <= (7 - currentWeekLastDay); i++) {
        NSString * string = [NSString stringWithFormat:@"%ld%02ld%02ld",lastYear,lastMonth,i];
        [self.dayArray addObject:string];
    }
    
    self.dateBlock(_year, _month);
    
    //上个月的index和
    self.lastMonthIndex = currentWeekFirstDay - 2;
    //下个月的index和
    self.nextMonthIndex = 7 - currentWeekLastDay;
    //当天index（currentIndex）
    NSDate *nowDateSystem = [NSDate date];
    NSString *nowDateStrSystem = [dateFm stringFromDate:nowDateSystem];
    if ([nowDateStrSystem isEqualToString:[NSString stringWithFormat:@"%ld%02ld",_year,_month]]) {
        self.currentIndex = currentWeekFirstDay - 2 + self.day;
    }else{
        self.currentIndex = 10000;
    }
    return self.dayArray;
    
}
//计算每月的天数 (这个月有几天 就传当天的日期)
- (NSRange)totalDaysInMonth:(NSDate *)date {
    
    NSRange totalDays = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totalDays;

}
// 计算本月第一天是周几
- (NSInteger)currentMonthFirstDayInWeek {
    
    //本月第一天的日期对象（NSDate）
    NSDate *nowMonthfirstDay = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",_year,_month,1]];
    //本月第一天是星期几
    NSDateComponents * components = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:nowMonthfirstDay];
    //WeekDay 表示周里面的天 1代表周日 2代表周一 7代表周六
    return components.weekday;

    
}
// 计算本月最后一天是周几
- (NSInteger)currentMonthLastDayInWeek {

    NSDate * nowDate = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",_year,_month,_day]];
    //计算每月的天数 (这个月有几天 就传当天的日期)
    NSRange totalDays =  [self totalDaysInMonth:nowDate];

    //本月最后一天的日期对象（NSDate）
    NSDate *nowMonthfirstDay = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%lu",_year,_month,(unsigned long)totalDays.length]];
    //本月第一天是星期几
    NSDateComponents * components = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:nowMonthfirstDay];
    //WeekDay 表示周里面的天 1代表周日 2代表周一 7代表周六
    return components.weekday;
    
}


//返回上个月第一天的NSDate对象
- (NSDate *)setLastMonthWithDay {
    NSDate * date = nil;
    if (self.month != 1) {
        
        date = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",self.year,self.month-1,01]];
        
    }else{
        
        date = [self.dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%d-%d",self.year - 1,12,01]];
    }
    return date;
}


@end
