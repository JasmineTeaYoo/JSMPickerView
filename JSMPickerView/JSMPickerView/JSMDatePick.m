//
//  JSMDatePick.m
//  JSMPickerView
//
//  Created by yuyi_liu on 2017/11/7.
//  Copyright © 2017年 yuyigufen. All rights reserved.
//

#import "JSMDatePick.h"
#import "NSDate+Date.h"
@interface JSMDatePick ()
//设置日期最大最小年限
@property(nonatomic,assign) NSInteger maxYear;
@property(nonatomic,assign) NSInteger minYear;
//数据源数组
@property (strong, nonatomic) NSMutableArray *yearArray;//年
@property (strong, nonatomic) NSMutableArray *monthArray;//月
@property (strong, nonatomic) NSMutableArray *dayArray;//日
//记录位置
@property (assign, nonatomic)NSInteger yearIndex;
@property (assign, nonatomic)NSInteger monthIndex;
@property (assign, nonatomic)NSInteger dayIndex;
//当前年月日
@property (copy, nonatomic) NSString *currentYear;
@property (copy, nonatomic) NSString *currentMonth;
@property (copy, nonatomic) NSString *currentDay;
@end

@implementation JSMDatePick
- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    self.pickerTitle = @"请选择出生日期";
    [self initData];// 初始化数据
    [self showCurrentDate];// 显示当前日期
}

-(void)initData{
    self.maxYear = 2020;
    self.minYear = 1900;
    
    self.yearArray = [[NSMutableArray alloc] init];
    self.monthArray = [[NSMutableArray alloc] init];
    self.dayArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = _minYear; i < _maxYear + 1; i++) {
        NSString *num = [NSString stringWithFormat:@"%zd",i];
        [_yearArray addObject:num];
    }
    for (int i=0; i<30; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (i>0 && i<=12) [_monthArray addObject:num];
        if (i>0) {
            [_dayArray addObject:num];
        }
    }
    self.JSMPickerdataArr = @[_yearArray,_monthArray,_dayArray];
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _yearIndex = row;
        self.currentYear = [self.yearArray objectAtIndex:row];
    }
    if (component == 1) {
        _monthIndex = row;
        self.currentMonth = [self.monthArray objectAtIndex:row];
    }
    if (component == 2) {
        _dayIndex = row;
        self.currentDay = [self.dayArray objectAtIndex:row];
    }
    
    if (component == 0 || component == 1){
        // 根据年月 确定天数
        [self daysfromYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
        // 刷新天数列表
        [self.pickView reloadComponent:2];
        // 由于天数是变动的，需刷新当前天数保存在_currentDay中
        NSInteger dayIndex = [self.pickView selectedRowInComponent:2];
        self.currentDay = self.dayArray[dayIndex];
    }
}

#pragma mark - privateMethods
-(void)cancleBtnClick{
    [super cancleBtnClick];
    NSLog(@"取消");
}

-(void)ensureBtnClick{
    [super ensureBtnClick];
    
    if ([self.delegate respondsToSelector:@selector(datePicker:withYear:month:day:)]) {
        [self.delegate datePicker:self withYear:_currentYear month:_currentMonth day:_currentDay];
    }
    
}

/** 获取当前年 */
- (NSString *)getCurrentYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate date]];
    return year;
}

/** 显示当前日期 */
-(void)showCurrentDate{
    NSString *date = [NSDate stringWithDate:[NSDate date]];
    NSString *dateStr = [date substringToIndex:10];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    self.currentYear = dateArr[0];
    self.currentMonth = dateArr[1];
    self.currentDay = dateArr[2];
    // 确定年 和 月
    _yearIndex= [self.yearArray indexOfObject:self.currentYear];
    _monthIndex = [self.monthArray indexOfObject:self.currentMonth];
    // 根据当前年月确定天数
    NSInteger currentMonthDays =  [self daysfromYear:[_yearArray[_yearIndex] integerValue] andMonth:[_monthArray[_monthIndex] integerValue]];
    [self setdayArray:currentMonthDays];
    _dayIndex = [self.dayArray indexOfObject:self.currentDay];
    // 滚动到当前日期
    [self.pickView selectRow:_yearIndex inComponent:0 animated:YES];
    [self.pickView selectRow:_monthIndex inComponent:1 animated:YES];
    [self.pickView selectRow:_dayIndex inComponent:2 animated:YES];
    // 刷新天数
    [self.pickView reloadComponent:2];
}

/** 通过年月求每月天数 */
- (NSInteger)daysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
        break;
    }
    return 0;
}

/** 设置每月的天数数组 */
- (void)setdayArray:(NSInteger)num
{
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}


@end
