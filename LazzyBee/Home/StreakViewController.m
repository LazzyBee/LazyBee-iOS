//
//  StreakViewController.m
//  LazzyBee
//
//  Created by HuKhong on 11/8/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import "StreakViewController.h"
#import "DayStatus.h"
#import "Common.h"

#define NUMBER_OF_DAYS 7

@interface StreakViewController ()

@end

@implementation StreakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSInteger streakCount = [[Common sharedCommon] getCountOfStreak];
    
    lbStreakCount.text = [NSString stringWithFormat:@"%ld day(s)", streakCount];
    
    lbCongratulation.text = [NSString stringWithFormat:@"Congratulation!\nYou have got %ld day(s) streak.", streakCount];
    
    [self displayDaysWithStreakStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)displayDaysWithStreakStatus {
    NSArray *streakArr = [[Common sharedCommon] loadStreak];
    NSMutableArray *dayStatusViewArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSTimeInterval dayInInterval = [[Common sharedCommon] getBeginOfDayInSec];
    
    DayStatus *statusView = nil;
    NSDate *date = nil;
    NSNumber *streakNumber = nil;
    
    for (int i = 0; i < NUMBER_OF_DAYS; i++) {
        dayInInterval = dayInInterval - 24*3600*1;
        date = [NSDate dateWithTimeIntervalSince1970:dayInInterval];
        
        if ([streakArr count] > i) {
            streakNumber = [streakArr objectAtIndex:i];
        }
        BOOL status = NO;
        
        if ([streakNumber doubleValue] == dayInInterval) {
            status = YES;
        }
        
        if (i == 0) {
            statusView = [[DayStatus alloc] initWithFrame:viewDayOne.frame];
            [viewDayOne addSubview:statusView];
            
        } else if (i == 1) {
            statusView = [[DayStatus alloc] initWithFrame:viewDayTwo.frame];
            [viewDayTwo addSubview:statusView];
            
        } else if (i == 2) {
            statusView = [[DayStatus alloc] initWithFrame:viewDayThree.frame];
            [viewDayThree addSubview:statusView];
            
        } else if (i == 3) {
            statusView = [[DayStatus alloc] initWithFrame:viewDayFour.frame];
            [viewDayFour addSubview:statusView];
            
        } else if (i == 4) {
            statusView = [[DayStatus alloc] initWithFrame:viewDayFive.frame];
            [viewDayFive addSubview:statusView];
            
        } else if (i == 5) {
            statusView = [[DayStatus alloc] initWithFrame:viewDaySix.frame];
            [viewDaySix addSubview:statusView];
            
        } else if (i == 6) {
            statusView = [[DayStatus alloc] initWithFrame:viewDaySeven.frame];
            [viewDaySeven addSubview:statusView];
        }
        CGRect rect = statusView.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        [statusView setFrame:rect];
        
        statusView.strDay = [dateFormatter stringFromDate:date];
        statusView.streakStatus = status;
        
        [dayStatusViewArray addObject:statusView];
    }
}
@end
