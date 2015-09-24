//
//  NYDateTimeTableViewCell.m
//  NYDateTimePicker
//
//  Created by 牛严 on 15/9/23.
//  Copyright (c) 2015年 牛严. All rights reserved.
//

#import "NYDateTimeTableViewCell.h"

@interface NYDateTimeTableViewCell ()

@property (strong,nonatomic) NSDateFormatter *myFomatter;
@property (strong,nonatomic) NSCalendar *calendar;
@property (strong,nonatomic) NSDate *selectedDate;
@property (strong,nonatomic) NSDate *pickerStartDate;
@property (strong,nonatomic) NSDate *pickEndDate;
@property (strong,nonatomic) NSDateComponents *selectedComponents;
@property NSInteger unitFlags;

@end


@implementation NYDateTimeTableViewCell

#pragma mark - UIView Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    self.datePickerView.hidden = YES;
    self.datePickerView.delegate = self;
    self.datePickerView.dataSource = self;
}

#pragma mark SubView Methods
-(void)reloadWithDate:(NSString *)dateString{
    [self setFomatter];
    self.dateTimeLabel.text = dateString;
    self.selectedDate = [self.myFomatter dateFromString:dateString];
    self.selectedComponents = [self.calendar components:self.unitFlags fromDate:self.selectedDate];
}

#pragma mark Private Methods
-(void)setFomatter{
    self.myFomatter = [[NSDateFormatter alloc]init];
    [self.myFomatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    self.calendar = [NSCalendar currentCalendar];
    self.selectedDate = [NSDate date];
    self.pickerStartDate = [self.myFomatter dateFromString:@"1900年2月1日 13:59"];
    self.pickEndDate = [self.myFomatter dateFromString:@"2100年12月31日 13:59"];
    self.unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;
}

#pragma mark Animation Methods
//模拟tableviewcell点击动画
-(void)grayViewAnimation{
    self.grayView.backgroundColor = [UIColor colorWithRed:208.f/255 green:208.f/255 blue:208.f/255 alpha:1.0f];
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.grayView.backgroundColor = [UIColor clearColor];
                     }];
}

//渐显
-(void)showPickerViewAnimation{
    [self grayViewAnimation];
    self.dateTimeLabel.textColor = [UIColor redColor];
    self.datePickerView.hidden = NO;
    [self.datePickerView setAlpha:0];
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.datePickerView setAlpha:1];
                     }];
}

//渐隐
-(void)fadePickerViewAnimation{
    self.dateTimeLabel.textColor = [UIColor blackColor];
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.datePickerView setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             self.datePickerView.hidden = YES;
                         }
                     }];
}

// 模拟datepicker setdate 方法
-(void)pickerViewSetDate:(NSDate *)date{
    NSDateComponents *temComponents = [[NSDateComponents alloc]init];
    temComponents = [self.calendar components:NSCalendarUnitYear fromDate:date];
    NSInteger yearRow = [temComponents year] - 1900;
    NSInteger monthRow = [[self.calendar components:NSCalendarUnitMonth fromDate:date] month] - 1;
    NSInteger dayRow = [[self.calendar components:NSCalendarUnitDay fromDate:date] day] - 1;
    NSInteger hourRow = [[self.calendar components:NSCalendarUnitHour fromDate:date] hour];
    NSInteger minRow = [[self.calendar components:NSCalendarUnitMinute fromDate:date] minute];
    [self.datePickerView selectRow:yearRow inComponent:0 animated:YES];
    [self.datePickerView selectRow:monthRow inComponent:1 animated:YES];
    [self.datePickerView selectRow:dayRow inComponent:2 animated:YES];
    [self.datePickerView selectRow:hourRow inComponent:3 animated:YES];
    [self.datePickerView selectRow:minRow inComponent:4 animated:YES];
}

#pragma mark IBAction Methods
- (IBAction)setDateButtonClicked:(id)sender {
    [self.delegate oneTimeCellHeightChange:self.ifChosen];
    if (!self.ifChosen) {
        [self pickerViewSetDate:self.selectedDate];
        self.ifChosen = !self.ifChosen;
        [self showPickerViewAnimation];
        [self grayViewAnimation];
    }else{
        self.ifChosen = !self.ifChosen;
        [self fadePickerViewAnimation];
        [self grayViewAnimation];
    }
}

#pragma mark - UIPickerViewDataSource Methods
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
        [dateLabel setFont:[UIFont systemFontOfSize:17]];
    }
    
    switch (component) {
        case 0: {
            NSDateComponents *components = [self.calendar components:NSCalendarUnitYear
                                                            fromDate:self.pickerStartDate];
            NSString *currentYear = [NSString stringWithFormat:@"%ld年", [components year] + row];
            [dateLabel setText:currentYear];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 1: {
            NSString *currentMonth = [NSString stringWithFormat:@"%ld月",(long)row+1];
            [dateLabel setText:currentMonth];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2: {
            NSRange dateRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                    inUnit:NSCalendarUnitMonth
                                                   forDate:self.selectedDate];
            
            NSString *currentDay = [NSString stringWithFormat:@"%lu日", (row + 1) % (dateRange.length + 1)];
            [dateLabel setText:currentDay];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 3:{
            NSString *currentHour = [NSString stringWithFormat:@"%ld时",(long)row];
            [dateLabel setText:currentHour];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 4:{
            NSString *currentMin = [NSString stringWithFormat:@"%02ld分",row];
            [dateLabel setText:currentMin];
            dateLabel.textAlignment = NSTextAlignmentCenter;
        }
        default:
            break;
    }
    
    return dateLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            NSDateComponents *startCpts = [self.calendar components:NSCalendarUnitYear
                                                           fromDate:self.pickerStartDate];
            NSDateComponents *endCpts = [self.calendar components:NSCalendarUnitYear
                                                         fromDate:self.pickEndDate];
            return [endCpts year] - [startCpts year] + 1;
        }
            
        case 1:
            return 12;
        case 2:{
            NSRange dayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                   inUnit:NSCalendarUnitMonth
                                                  forDate:self.selectedDate];
            return dayRange.length;
        }
        case 3:
            return 24;
        case 4:
            return 60;
        default:
            break;
    }
    return 0;
}

//每次修改都要执行的方法
-(void)changeDateLabel{
    self.selectedDate = [self.calendar dateFromComponents:self.selectedComponents];
    NSString *selectedDateString = [self.myFomatter stringFromDate:self.selectedDate];
    self.dateTimeLabel.text = selectedDateString;
    [self.delegate oneTimePickerValueChanged:selectedDateString];
}

#pragma mark - UIPickerViewDelegate Methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            NSInteger year = 1900 + row ;
            [self.selectedComponents setYear:year];
            [self changeDateLabel];
        }
            break;
        case 1:
        {
            [self.selectedComponents setMonth:row+1];
            [self changeDateLabel];
        }
            break;
        case 2:
        {
            [self.selectedComponents setDay:row +1];
            [self changeDateLabel];        }
            break;
        case 3:
        {
            [self.selectedComponents setHour:row];
            [self changeDateLabel];
        }
            break;
        case 4:
        {
            [self.selectedComponents setMinute:row];
            [self changeDateLabel];
        }
    }
    [self.datePickerView reloadAllComponents];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    return 35.0;
}

@end
