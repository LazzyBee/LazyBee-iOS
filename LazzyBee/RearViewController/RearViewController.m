//
//  RearViewController.m
//  LazzyBee
//
//  Created by HuKhong on 3/4/15.
//  Copyright (c) 2015 HuKhong. All rights reserved.
//

#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "RearViewController.h"
#import "Common.h"
#import "RearTableViewCell.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "DictionaryViewController.h"
#import "AboutViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>

@interface RearViewController()
{
    NSIndexPath *presentedCell;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;

- (void)viewDidLoad
{
	[super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [self.navigationController.navigationBar setTranslucent:NO];
    }
#endif
    [self.navigationController.navigationBar setBarTintColor:COMMON_COLOR];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBarHidden = YES;
    
    NSString *appVer = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    lbVersion.text = [NSString stringWithFormat:@"Version %@", appVer];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return TRUE;
}

#pragma mark - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return RearTable_Section_Max;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == RearTable_Section_Home) {
        return HomeSection_Max;
        
    } else if (section == RearTable_Section_Support) {
        return SupportSection_Max;
        
    } else if (section == RearTable_Section_Share) {
        return ShareSection_Max;
        
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle = @"";
    
    return headerTitle;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
//    header.textLabel.textColor = [UIColor darkGrayColor];
//    header.textLabel.font = [UIFont boldSystemFontOfSize:15];
//    CGRect headerFrame = header.frame;
//    header.textLabel.frame = headerFrame;
//    header.textLabel.textAlignment = NSTextAlignmentLeft;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *rearCellIdentifier = @"RearTableViewCell";
    
    RearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rearCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RearTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *text = @"";
    
    if (indexPath.section == RearTable_Section_Home) {
        if (indexPath.row == HomeSection_Home) {
            text = @"Home";
            cell.imgIcon.image = [UIImage imageNamed:@"ic_home"];
            
        } else if (indexPath.row == HomeSection_Dictionary) {
            text = @"Dictionary";
            cell.imgIcon.image = [UIImage imageNamed:@"ic_dictionary"];
        }
        
    } else if(indexPath.section == RearTable_Section_Support) {
        
        if (indexPath.row == SupportSection_Settings) {
            text = @"Settings";
            cell.imgIcon.image = [UIImage imageNamed:@"ic_setting"];
        }
        
    } else if(indexPath.section == RearTable_Section_Share) {
        if (indexPath.row == About_App) {
            text = @"About";
            cell.imgIcon.image = [UIImage imageNamed:@"ic_about"];
            
        } else if (indexPath.row == ShareSection_ShareFB) {
            text = @"Share";
            cell.imgIcon.image = [UIImage imageNamed:@"ic_share"];
        }
    }

    cell.lbTitle.text = text;
    cell.backgroundColor = [UIColor clearColor];
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
    // we'll just set position and return
    if ([indexPath isEqual:presentedCell]) {
        [self.sidePanelController showCenterPanelAnimated:YES];
        return;
    }

    // otherwise we'll create a new frontViewController and push it with animation

    UIViewController *newFrontController = nil;
    if (indexPath.section == RearTable_Section_Home) {
        if (indexPath.row == HomeSection_Home) {
            HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            
            newFrontController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            
            self.sidePanelController.centerPanel = newFrontController;
            
            presentedCell = indexPath;  // <- store the presented row
            
        } else if (indexPath.row == HomeSection_Dictionary) {
            DictionaryViewController *dictionaryViewController = [[DictionaryViewController alloc] initWithNibName:@"DictionaryViewController" bundle:nil];
            
            newFrontController = [[UINavigationController alloc] initWithRootViewController:dictionaryViewController];
            
            self.sidePanelController.centerPanel = newFrontController;
            
            presentedCell = indexPath;  // <- store the presented row
        }
        
    } else if (indexPath.section == RearTable_Section_Support) {
        if (indexPath.row == SupportSection_Settings) {
            SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            
            newFrontController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
            
            self.sidePanelController.centerPanel = newFrontController;
            
            presentedCell = indexPath;  // <- store the presented row
        }
        
    } else if (indexPath.section == RearTable_Section_Share) {
        if (indexPath.row == About_App) {
            AboutViewController *aboutView = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            
            newFrontController = [[UINavigationController alloc] initWithRootViewController:aboutView];
            
            self.sidePanelController.centerPanel = newFrontController;
            
            presentedCell = indexPath;  // <- store the presented row
            
        } else if (indexPath.row == ShareSection_ShareFB) {
            FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
            content.contentURL = [NSURL URLWithString:@"http://www.lazzybee.com"];
            
            FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
            shareDialog.shareContent = content;
            
            shareDialog.delegate = (id)self;
            [shareDialog show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex != 0) {
            
        }
    }
    
}
#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"completed share:%@", results);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"sharing error:%@", error);
    NSString *message = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?:
    @"Failed to sharing";
    NSString *title = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops!";
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"share cancelled");
}

@end