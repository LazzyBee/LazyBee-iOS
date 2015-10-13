//
//  DailyTargetViewController.h
//  LazzyBee
//
//  Created by HuKhong on 9/10/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NewWordTargetType = 0,
    TotalTargetType
} TARGET_TYPE;

@interface DailyTargetViewController : UIViewController
{
    
}

@property (nonatomic, assign) TARGET_TYPE targetType;
@end
