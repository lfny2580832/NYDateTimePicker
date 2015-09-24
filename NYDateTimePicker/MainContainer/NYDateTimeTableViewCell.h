//
//  NYDateTimeTableViewCell.h
//  NYDateTimePicker
//
//  Created by 牛严 on 15/9/23.
//  Copyright (c) 2015年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NYDateTimeDelegate;

@interface NYDateTimeTableViewCell : UITableViewCell<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *grayView;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *datePickerView;
@property BOOL ifChosen;
@property (assign, nonatomic) id<NYDateTimeDelegate> delegate;

-(void)reloadWithDate:(NSString *)dateString;
-(void)pickerViewSetDate:(NSDate *)date;
-(void)grayViewAnimation;
-(void)showPickerViewAnimation;
-(void)fadePickerViewAnimation;

@end

@protocol NYDateTimeDelegate <NSObject>
//更改高度
-(void)oneTimeCellHeightChange:(BOOL)ifChosen;
//更改内容
-(void)oneTimePickerValueChanged:(NSString *)dateString;

@end
