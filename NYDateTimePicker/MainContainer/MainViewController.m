//
//  MainViewController.m
//  NYDateTimePicker
//
//  Created by 牛严 on 15/9/22.
//  Copyright (c) 2015年 牛严. All rights reserved.
//

#import "MainViewController.h"
#import "NYDateTimeTableViewCell.h"
#import "NYDateTableViewCell.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,NYDateTimeDelegate,NYDatePickerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NYDateTableViewCell *dateCell;
@property (strong, nonatomic) NYDateTimeTableViewCell *timeCell;
@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSString *dateString;
@property NSInteger timeIfChosen;
@property NSInteger dateIfChosen;
@end

@implementation MainViewController
#pragma mark Private Methods
- (void)setDefaultDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    self.timeString = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    self.dateString = [formatter stringFromDate:[NSDate date]];
}

- (void)reloadCellAnimate{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark UIView Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self setDefaultDate];
}

#pragma mark NYDateTimeDelegate
- (void)oneTimeCellHeightChange:(BOOL)ifChosen{
    if(!ifChosen){
        self.timeIfChosen = 1;
        //缩回其他cell
        [self shrinkDatePickerCell];
    }else{
        self.timeIfChosen = 0;
    }
    [self reloadCellAnimate];
}

- (void)oneTimePickerValueChanged:(NSString *)dateString{
    self.timeString = dateString;
}

#pragma mark NYDateDelegate
-(void)oneDatePickerValueChanged:(NSString *)dateString{
    self.dateString = dateString;
}

-(void)oneDateCellHeightChange:(BOOL)ifChosen{
    if (!ifChosen) {
        self.dateIfChosen = 1;
        [self shrinkDateTimePickerCell];
    }else{
        self.dateIfChosen = 0;
    }
    [self reloadCellAnimate];
}


#pragma mark 改变cell高度方法,在beginupdates endupdates中使用
-(void)shrinkDateTimePickerCell{
    self.timeIfChosen = 0;
    [self.timeCell fadePickerViewAnimation];
    self.timeCell.ifChosen = NO;
}

-(void)shrinkDatePickerCell{
    self.dateIfChosen = 0;
    [self.dateCell fadePickerViewAnimation];
    self.dateCell.ifChosen = NO;
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            self.timeCell = [tableView dequeueReusableCellWithIdentifier:@"NYDateTimeTableViewCell"];
            self.timeCell = [[[NSBundle mainBundle] loadNibNamed:@"NYDateTimeTableViewCell" owner:self options:nil]lastObject];
            self.timeCell.delegate = self;
            [self.timeCell reloadWithDate:self.timeString];
            return self.timeCell;
        }
            break;
            
        case 1:{
            self.dateCell = [tableView dequeueReusableCellWithIdentifier:@"NYDateTableViewCell"];
            self.dateCell = [[[NSBundle mainBundle] loadNibNamed:@"NYDateTableViewCell" owner:self options:nil]lastObject];
            self.dateCell.delegate = self;
            [self.dateCell reloadWithDate:self.dateString];
            return self.dateCell;
        }
            break;
    }
    return nil;
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        if (self.timeIfChosen != 0)     return 235.f;
    }
    if(indexPath.row == 1){
        if (self.dateIfChosen != 0)     return 235.f;
    }
    return 40.f;
}

@end
