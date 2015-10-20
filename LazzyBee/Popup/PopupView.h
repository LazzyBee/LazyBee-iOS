//
//  PopupView.h
//  LazzyBee
//
//  Created by HuKhong on 10/15/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView
{

    
}
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UILabel *lbInfo;


@property (nonatomic, strong) NSString *popupText;
@property (nonatomic, strong) NSString *popupURL;
@end
