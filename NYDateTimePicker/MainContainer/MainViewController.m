//
//  MainViewController.m
//  NYDateTimePicker
//
//  Created by 牛严 on 15/9/22.
//  Copyright (c) 2015年 牛严. All rights reserved.
//

#import "MainViewController.h"
#import "NYDateTimeTableViewCell.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,NYDateTimeDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSIndexPath *dateCellPath;
@property NSInteger timeIsChosen;
@end

@implementation MainViewController
#pragma mark Private Methods
- (void)setDefaultDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    self.timeString = [formatter stringFromDate:[NSDate date]];
}

#pragma mark UIView Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib1 = [UINib nibWithNibName:@"NYDateTimeTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"NYDateTimeTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self setDefaultDate];
}

#pragma mark NYDateTimeDelegate
- (void)oneDateTimeCellHeightChange:(BOOL)ifChosen{
    if(!ifChosen){
        self.timeIsChosen = 1;
    }else{
        self.timeIsChosen = 0;
    }
    //===========================缩回其他cell===============
    
    //=====================================================
    [self.tableView beginUpdates];
    [self.tableView endUpdates];

}

- (void)oneDateTimePickerValueChanged:(NSString *)dateString{
    self.timeString = dateString;
}

#pragma mark 改变cell高度方法


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
            self.dateCellPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.datePickerView.hidden = YES;
            cell.delegate = self;
            [cell reloadWithDate:self.timeString];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        if (self.timeIsChosen != 0) {
            return 235.f;
            
        }else{
            return 40.f;
        }
    }
    return 40.f;
}


@end
