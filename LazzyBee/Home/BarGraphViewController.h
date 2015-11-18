//
//  BarGraphViewController.h
//  LazzyBee
//
//  Created by HuKhong on 11/17/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphKit.h"

@interface BarGraphViewController : UIViewController<GKBarGraphDataSource>
{
    IBOutlet GKBarGraph *graphView;
    
    IBOutlet UILabel *lbStreakCount;
    IBOutlet UIImageView *imgRingStreak;
    IBOutlet UIView *streakView;
    
    IBOutlet UIScrollView *scrollViewContainer;
}



@end
