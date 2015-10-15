//
//  PopupView.m
//  LazzyBee
//
//  Created by HuKhong on 10/15/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView
{
    NSTimer *timer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"PopupView" owner:self options:nil];
        CGRect rect = self.view.frame;
        rect.size.height = frame.size.height;
        rect.size.width = frame.size.width;
        [self.view setFrame:rect];
        
        [self addSubview:self.view];
        
        self.view.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.view.layer.borderWidth = 3.0f;
        
        self.view.layer.cornerRadius = 5.0f;
        self.view.clipsToBounds = YES;
        
        self.view.layer.masksToBounds = NO;
        self.view.layer.shadowOffset = CGSizeMake(-5, 10);
        self.view.layer.shadowRadius = 5;
        self.view.layer.shadowOpacity = 0.5;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(closePopup) userInfo:nil repeats:NO];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}

- (IBAction)gestureTapHandle:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_popupURL]];
}

- (void)closePopup {
    [UIView animateWithDuration:1 animations:^(void) {
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
