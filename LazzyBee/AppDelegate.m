//
//  AppDelegate.m
//  LazzyBee
//
//  Created by nobody on 7/31/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "RearViewController.h"
#import "JASidePanelController.h"
#import "CommonSqlite.h"
#import "CommonDefine.h"
#import "Common.h"

#import "TAGContainer.h"
#import "TAGContainerOpener.h"
#import "TAGManager.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

// TAGContainerOpenerNotifier callback.
- (void)containerAvailable:(TAGContainer *)container {
    // Note that containerAvailable may be called on any thread, so you may need to dispatch back to
    // your main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.container = container;
    });
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self copyDatabaseIntoDocumentsDirectory];
    [self initialConfiguration];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        
    RearViewController *rearViewController = [[RearViewController alloc] init];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    JASidePanelController *jaSidePanel = [[JASidePanelController alloc] init];
    jaSidePanel.leftPanel = rearNavigationController;
    jaSidePanel.centerPanel = homeNav;
    
    jaSidePanel.bounceOnCenterPanelChange = NO;
    jaSidePanel.shouldResizeLeftPanel = YES;
    jaSidePanel.leftFixedWidth = 260;
    
    self.window.rootViewController = jaSidePanel;
    [self.window makeKeyAndVisible];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    //Google TagManager
    self.tagManager = [TAGManager instance];
    
    // Optional: Change the LogLevel to Verbose to enable logging at VERBOSE and higher levels.
    [self.tagManager.logger setLogLevel:kTAGLoggerLogLevelVerbose];
    
    /*
     * Opens a container.
     *
     * @param containerId The ID of the container to load.
     * @param tagManager The TAGManager instance for getting the container.
     * @param openType The choice of how to open the container.
     * @param timeout The timeout period (default is 2.0 seconds).
     * @param notifier The notifier to inform on container load events.
     */
    [TAGContainerOpener openContainerWithId:@"GTM-M6SZR5"
                                 tagManager:self.tagManager
                                   openType:kTAGOpenTypePreferFresh
                                    timeout:nil
                                   notifier:self];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self scheduleNotification];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self scheduleNotification];
}


- (void)copyDatabaseIntoDocumentsDirectory {
    NSString *destinationPath = [[[Common sharedCommon] documentsFolder] stringByAppendingPathComponent:DATABASENAME];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
    
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASENAME];

        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];

        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

- (void)initialConfiguration {
    NSNumber *speedNumberObj = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"SpeakingSpeed"];
    
    if (!speedNumberObj) {
        speedNumberObj = [NSNumber numberWithFloat:0.5];
        [[Common sharedCommon] saveDataToUserDefaultStandard:speedNumberObj withKey:@"SpeakingSpeed"];
    }
    
    NSString *remindTime = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"RemindTime"];
    
    if (!remindTime) {
        remindTime = @"08:00";
        [[Common sharedCommon] saveDataToUserDefaultStandard:remindTime withKey:@"RemindTime"];
    }
    
    NSNumber *reminderNumberObj = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"ReminderOnOff"];
    
    if (!reminderNumberObj) {
        reminderNumberObj = [NSNumber numberWithBool:YES];
        [[Common sharedCommon] saveDataToUserDefaultStandard:reminderNumberObj withKey:@"ReminderOnOff"];
    }
    
    NSNumber *targetNumberObj = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"DailyTarget"];
    
    if (!targetNumberObj) {
        targetNumberObj = [NSNumber numberWithInteger:10];
        [[Common sharedCommon] saveDataToUserDefaultStandard:targetNumberObj withKey:@"DailyTarget"];
    }
}

- (void)scheduleNotification {
    NSNumber *reminderNumberObj = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"ReminderOnOff"];
    BOOL notificationFlag = YES;
    
    if (reminderNumberObj) {
        notificationFlag = [reminderNumberObj boolValue];
    }
    
    NSInteger count = [[CommonSqlite sharedCommonSqlite] getCountOfPickedWord];    
    
    if (notificationFlag && count > 0) {
        UILocalNotification *locNotification = [[UILocalNotification alloc] init];
        
        NSString *beginOfDay = [[Common sharedCommon] getCurrentDatetimeWithFormat:@"dd/MM/yyyy"];
        NSString *remindTime = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"RemindTime"];
        
        beginOfDay = [NSString stringWithFormat:@"%@ %@", beginOfDay, remindTime];
        
        locNotification.fireDate = [[Common sharedCommon] dateFromString:beginOfDay];
        locNotification.alertBody = @"Lazzy Bee! It's about to learn.";
        locNotification.repeatCalendar = [NSCalendar currentCalendar];
        locNotification.repeatInterval = kCFCalendarUnitWeekday;
        locNotification.soundName = UILocalNotificationDefaultSoundName;
        locNotification.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:locNotification];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


@end
