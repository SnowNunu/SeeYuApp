//
//  NSDate+Extension.m
//  YBJY
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 YouBeiJiaYuan. All rights reserved.
//

#import "NSDate+Extension.h"


#define DATE_COMPONENTS (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear |  NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)


#define CURRENT_CALENDAR [NSCalendar currentCalendar]



@implementation NSDate (Extension)
/**
 *  是否为今天
 */
- (BOOL)sy_isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[self getLocalDateFormatAnyDate:[NSDate date]]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)sy_isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] sy_dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self sy_dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)sy_dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}


/**
 *  是否为今年
 */
- (BOOL)sy_isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}


// This hard codes the assumption that a week is 7 days
- (BOOL) sy_isSameWeekWithAnotherDate: (NSDate *)anotherDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:anotherDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfMonth != components2.weekOfMonth) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:anotherDate]) < SY_D_WEEK);
}

/**
 *  星期几
 */
- (NSString *)sy_weekDay
{
    NSArray *weekDays = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    
//    NSLog(@"NSCalendarUnitWeekday--  components.weekday = %zd  -- components.weekdayOrdinal = %zd  -- components.weekOfYear = %zd  -- components.weekOfMonth = %zd",components.weekday , components.weekdayOrdinal , components.weekOfYear , components.weekOfMonth);
    
    return weekDays[components.weekday - 1];
}



- (BOOL) sy_isThisWeek
{
    return [self sy_isSameWeekWithAnotherDate:[NSDate date]];
}


/**
 *  通过一个时间 固定的时间字符串 "2016/8/10 14:43:45" 返回时间
 *
 *  @param timestamp 固定的时间字符串 "2016/8/10 14:43:45"
 *
 *  @return 时间
 */
+ (instancetype)sy_dateWithTimestamp:(NSString *)timestamp
{
    return [[NSDateFormatter sy_defaultDateFormatter] dateFromString:timestamp];
}


/**
 *  返回固定的 当前时间 2016-8-10 14:43:45
 */
+ (NSString *)sy_currentTimestamp
{
    return [[NSDateFormatter sy_defaultDateFormatter] stringFromDate:[NSDate date]];
}

/**
 *  返回当前时间的年份
 */
+ (NSString *)sy_currentYear
{
    return [[[NSDateFormatter sy_defaultDateFormatter] stringFromDate:[NSDate date]] substringToIndex:4];
}

/**
 * 格式化日期描述
 */
- (NSString *)sy_formattedDateDescription
{
    NSDateFormatter *dateFormatter = nil;
    NSString *result = nil;
    
    if ([self sy_isThisYear])
    {
        // 今年
        if ([self sy_isToday]) {
            // 22:22
            dateFormatter = [NSDateFormatter sy_dateFormatterWithFormat:@"HH:mm"];
        }else if ([self sy_isYesterday]){
            // 昨天 22:22
            dateFormatter = [NSDateFormatter sy_dateFormatterWithFormat:@"昨天 HH:mm"];
        }else if ([self sy_isThisWeek]){
            // 星期二 22:22
            dateFormatter = [NSDateFormatter sy_dateFormatterWithFormat:[NSString stringWithFormat:@"%@ HH:mm" , [self sy_weekDay]]];
        }else{
            // 2016年08月18日 22:22
            dateFormatter = [NSDateFormatter sy_dateFormatterWithFormat:@"yyyy年MM月dd日 HH:mm"];
        }
        
    }else{
        // 非今年
        dateFormatter = [NSDateFormatter sy_dateFormatterWithFormat:@"yyyy年MM月dd日"];
    }
    
    result = [dateFormatter stringFromDate:self];
    
    return result;
}

/** 与当前时间的差距 */
- (NSDateComponents *)sy_deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}


//////////// MVC&MVVM的商品的发布时间的描述 ////////////
- (NSString *)sy_string_yyyy_MM_dd {
    return [self sy_string_yyyy_MM_dd:[NSDate date]];
}

- (NSString *)sy_string_yyyy_MM_dd:(NSDate *)toDate {
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    // fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    // fmt.locale = [NSLocale currentLocale];
    
    // 由于小闲肉使用的是北京时间，需要减掉8小时时差(转为欧美时间体系)
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:(self.timeIntervalSince1970 - 8*60*60)];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    
    if (cmps.year == 0) { // 今年
        if (cmps.year == 0 && cmps.month == 0 && cmps.day == 1) { // 昨天
            // fmt.dateFormat = @"昨天 HH:mm";
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:fromDate];
        } else if (cmps.year == 0 && cmps.month == 0 && cmps.day == 0) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:fromDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:fromDate];
    }
}
//////////// MVC&MVVM的商品的发布时间的描述 ////////////


- (NSDate *)getLocalDateFormatAnyDate:(NSDate *)anyDate {
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    NSTimeZone *desTimeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [desTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

/**
 * 判断当前时间对比传入的时间是否过期
 */
+ (BOOL)sy_overdue:(NSDate *)date {
    // 这里直接将服务器的时间设置为了UTC0，所以要减去8个小时
    NSTimeInterval time = [date timeIntervalSinceNow] - 3600 * 8;
    if (time > 0) {
        return NO;
    } else {
        return YES;
    }
}

@end
