//
//  DictDetailViewController.h
//  LazzyBee
//
//  Created by HuKhong on 10/7/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordObject.h"

typedef enum {
    DictVietnam = 0,
    DictEnglish,
    DictLazzyBee,
    DictMax,
} DICTIONARY_TYPE;

@interface DictDetailViewController : UIViewController
{
    IBOutlet UIWebView *webviewWord;
    
}

@property (nonatomic, strong) WordObject *wordObj;
@property (nonatomic, assign) DICTIONARY_TYPE dictType;
@end
