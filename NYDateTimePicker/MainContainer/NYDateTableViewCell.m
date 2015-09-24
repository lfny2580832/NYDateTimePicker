//
//  NYDateTableViewCell.m
//  NYDateTimePicker
//
//  Created by 牛严 on 15/9/24.
//  Copyright (c) 2015年 牛严. All rights reserved.
//

#import "NYDateTableViewCell.h"


@interface NYDateTableViewCell ()
@property (strong,nonatomic) NSDateFormatter *myFomatter;
@property (strong,nonatomic) NSDate *chosenDate;
@end

@implementation NYDateTableViewCell

#pragma mark - UIView Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    self.datePicker.hidden = YES;
}

-(void)pickerViewSetDate:(NSDate *)date{
    [self.datePicker setDate:date];
}

#pragma mark Private Methods
-(void)reloadWithDate:(NSString *)dateString{
    self.myFomatter = [[NSDateFormatter alloc]init];
    [self.myFomatter setDateFormat:@"yyyy年MM月dd日"];
    self.dateLabel.text = dateString;
    self.chosenDate = [self.myFomatter dateFromString:dateString];
}

#pragma mark Animation Methods
-(void)grayViewAnimation{
    self.grayView.backgroundColor = [UIColor colorWithRed:208.f/255 green:208.f/255 blue:208.f/255 alpha:1.0f];
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.grayView.backgroundColor = [UIColor clearColor];
                     }];
}

//渐显
-(void)showPickerViewAnimation{
    self.dateLabel.textColor = [UIColor redColor];
    self.datePicker.hidden = NO;
    [self.datePicker setAlpha:0];
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.datePicker setAlpha:1];
                     }];
}

//渐隐
-(void)fadePickerViewAnimation{
    self.dateLabel.textColor = [UIColor blackColor];
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.datePicker setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             self.datePicker.hidden = YES;
                         }
                     }];
}

#pragma mark IBAction Methods
- (IBAction)datePickerValueChange:(UIDatePicker *)datePicker {
    NSString *dateString = [self.myFomatter stringFromDate:datePicker.date];
    self.dateLabel.text = dateString;
    self.chosenDate = [self.myFomatter dateFromString:dateString];
    [self.delegate oneDatePickerValueChanged:dateString];
}

- (IBAction)setDateButtonClicked:(id)sender {
    [self.delegate oneDateCellHeightChange:self.ifChosen];
    if (self.ifChosen == NO) {
        [self.datePicker setDate:self.chosenDate];
        self.ifChosen = YES;
        [self showPickerViewAnimation];
        [self grayViewAnimation];
    }else{
        self.ifChosen = NO;
        [self fadePickerViewAnimation];
        [self grayViewAnimation];
    }
}

@end
