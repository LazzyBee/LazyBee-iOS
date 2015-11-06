//
//  DayStatus.m
//  LazzyBee
//
//  Created by HuKhong on 11/9/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import "DayStatus.h"

@implementation DayStatus


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"DayStatus" owner:self options:nil];
        CGRect rect = self.view.frame;
        rect.size.height = frame.size.height;
        rect.size.width = frame.size.width;
        rect.origin.x = 0;
        rect.origin.y = 0;
        [self.view setFrame:rect];
        [self addSubview:self.view];
/*        self.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.view.layer.borderWidth = 3.0f;
        
        self.view.layer.cornerRadius = 5.0f;
        self.view.clipsToBounds = YES;
        
        self.view.layer.masksToBounds = NO;
        self.view.layer.shadowOffset = CGSizeMake(-5, 10);
        self.view.layer.shadowRadius = 5;
        self.view.layer.shadowOpacity = 0.5;*/
        
        if (_streakStatus) {
            [imgRing setImage:[UIImage imageNamed:@"day_ring"]];
        } else {
            [imgRing setImage:[UIImage imageNamed:@"day_ring_gray"]];
        }
        
        lbDay.text = _strDay;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setStrDay:(NSString *)strDay {
    _strDay = strDay;
    lbDay.text = [strDay substringToIndex:3];
}

- (void)setStreakStatus:(BOOL)streakStatus {
    _streakStatus = streakStatus;
    if (streakStatus) {
        [imgRing setImage:[UIImage imageNamed:@"day_ring"]];
    } else {
        [imgRing setImage:[UIImage imageNamed:@"day_ring_gray"]];
    }
}

@end
