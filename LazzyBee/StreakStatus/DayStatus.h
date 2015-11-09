//
//  DayStatus.h
//  LazzyBee
//
//  Created by HuKhong on 11/9/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayStatus : UIView
{
    IBOutlet UIImageView *imgRing;
    IBOutlet UILabel *lbDay;
    
}

@property (strong, nonatomic) IBOutlet UIView *view;


@property (strong, nonatomic) NSString *strDay;
@property (assign, nonatomic) BOOL streakStatus;

@end
