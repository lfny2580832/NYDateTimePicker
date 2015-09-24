//
//  NYDateTableViewCell.h
//  NYDateTimePicker
//
//  Created by 牛严 on 15/9/24.
//  Copyright (c) 2015年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NYDatePickerDelegate;

@interface NYDateTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *grayView;
@property (assign) NSInteger ShowAndDisapper;
@property BOOL ifChosen;

@property (assign, nonatomic) id<NYDatePickerDelegate> delegate;

-(void)reloadWithDate:(NSString *)dateString;
-(void)pickerViewSetDate:(NSDate *)date;
-(void)grayViewAnimation;
-(void)fadePickerViewAnimation;
-(void)showPickerViewAnimation;

@end

@protocol NYDatePickerDelegate <NSObject>


-(void)oneDateCellHeightChange:(BOOL)ifChosen;
-(void)oneDatePickerValueChanged:(NSString *)dateString;

@end