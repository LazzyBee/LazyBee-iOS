//
//  CommonDefine.h
//  LazzyBee
//
//  Created by HuKhong on 4/19/15.
//  Copyright (c) 2015 HuKhong. All rights reserved.
//

#ifndef LazzyBee_CommonDefine_h
#define LazzyBee_CommonDefine_h
#import <Foundation/Foundation.h>

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) && ((IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale) || !IS_OS_8_OR_LATER))
#define IS_STANDARD_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)
#define IS_ZOOMED_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)
#define IS_STANDARD_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_ZOOMED_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)

//#define COMMON_COLOR [UIColor colorWithRed:243/255.f green:111/255.f blue:33/255.f alpha:1]
//#define COMMON_COLOR [UIColor colorWithRed:100/255.f green:142/255.f blue:45/255.f alpha:1]
#define COMMON_COLOR [UIColor colorWithRed:255/255.f green:200/255.f blue:47/255.f alpha:1]

#define SERVER_LINK  @"http://192.168.0.202"
#define REQUEST_HOME @""

#define DATABASENAME @"english.db"

#define BUFFER_SIZE 100
#define PICKED_WORDS_QUEUE_SIZE 10
#define TOTAL_WORDS_A_DAY_MAX 30

@interface CommonDefine : NSObject


@end

#endif
