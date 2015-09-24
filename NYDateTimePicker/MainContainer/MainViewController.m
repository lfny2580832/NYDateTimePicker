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
@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSIndexPath *timeCellPath;
@property (strong, nonatomic) NSIndexPath *dateCellPath;
@property NSInteger timeIsChosen;
@property NSInteger dateIsChosen;
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

#pragma mark UIView Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib1 = [UINib nibWithNibName:@"NYDateTimeTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"NYDateTimeTableViewCell"];
    UINib *nib2 = [UINib nibWithNibName:@"NYDateTableViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"NYDateTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self setDefaultDate];
}

#pragma mark NYDateTimeDelegate
- (void)oneDateTimeCellHeightChange:(BOOL)ifChosen{
    if(!ifChosen){
        self.timeIsChosen = 1;
        //===========================缩回其他cell===============
        [self shrinkDatePickerCellWithType:2];
        //=====================================================
    }else{
        self.timeIsChosen = 0;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)oneDateTimePickerValueChanged:(NSString *)dateString{
    self.timeString = dateString;
}

#pragma mark NYDateDelegate
-(void)oneDatePickerValueChanged:(NSString *)dateString{
    self.dateString = dateString;
}

-(void)oneDateCellHeightChange:(BOOL)ifChosen{
    if (!ifChosen) {
        self.dateIsChosen = 1;
        //===========================缩回其他cell===============
        [self shrinkDateTimePickerCellWithType:2];
        //=====================================================
    }else{
        self.dateIsChosen = 0;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
#pragma mark 改变cell高度方法
//收回年月日时分cell,在beginupdates endupdates中使用
-(void)shrinkDateTimePickerCellWithType:(NSInteger)type{
    
    self.timeIsChosen = 0;
    NYDateTimeTableViewCell *cell = (NYDateTimeTableViewCell *)[self.tableView cellForRowAtIndexPath:self.timeCellPath];
    if (type == 0) {
        [cell grayViewAnimation];
    }
    [cell fadePickerViewAnimation];
    cell.ifChosen = NO;
}

//收回年月日cell,在beginupdates endupdates中使用
-(void)shrinkDatePickerCellWithType:(NSInteger)type{
    self.dateIsChosen = 0;
    NYDateTableViewCell *cell = (NYDateTableViewCell *)[self.tableView cellForRowAtIndexPath:self.dateCellPath];
    if (type == 0) {
        [cell grayViewAnimation];
    }
    [cell fadePickerViewAnimation];
    cell.ifChosen = NO;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            static NSString *cellIdentity = @"NYDateTimeTableViewCell";
            NYDateTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (nil == cell) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NYDateTimeTableViewCell" owner:self options:nil];
                cell = [nibs lastObject];
            }
            self.timeCellPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.datePickerView.hidden = YES;
            cell.delegate = self;
            [cell reloadWithDate:self.timeString];
            return cell;
        }
            break;
            
        case 1:{
            static NSString *cellIdentity = @"NYDateTableViewCell";
            NYDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (nil == cell) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NYDateTableViewCell" owner:self options:nil];
                cell = [nibs lastObject];
            }
            self.dateCellPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.datePicker.hidden = YES;
            [cell reloadWithDate:self.dateString];
            return cell;
        }
            break;
   
        default:
            break;
    }
    return nil;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        if (self.timeIsChosen != 0) {
            return 235.f;
            
        }else{
            return 40.f;
        }
    }
    if(indexPath.row == 1){
        if (self.dateIsChosen != 0) {
            return 235.f;
            
        }else{
            return 40.f;
        }
    }
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
