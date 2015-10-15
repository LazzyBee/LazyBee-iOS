//
//  DictDetailContainerViewController.m
//  LazzyBee
//
//  Created by HuKhong on 10/8/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import "DictDetailContainerViewController.h"
#import "DictDetailViewController.h"
#import "MHTabBarController.h"
#import "TagManagerHelper.h"
#import "CommonSqlite.h"
#import "AppDelegate.h"

@interface DictDetailContainerViewController ()
{
    MHTabBarController *tabViewController;
}
@end

@implementation DictDetailContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [TagManagerHelper pushOpenScreenEvent:@"iDictionaryViewWordScreen"];
    
    [self setTitle:_wordObj.question];
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionsPanel)];
    
    self.navigationItem.rightBarButtonItems = @[actionButton];
    
    //admob
    GADRequest *request = [GADRequest request];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TAGContainer *container = appDelegate.container;
    BOOL enableAds = [[container stringForKey:@"adv_enable"] boolValue];
    
    if (enableAds) {
        _adBanner.hidden = NO;
        NSString *advStr = [NSString stringWithFormat:@"%@/%@", [container stringForKey:@"g_pub_id"],[container stringForKey:@"adv_home_id"] ];
        
        self.adBanner.adUnitID = advStr;//@"ca-app-pub-3940256099942544/2934735716";
        
        self.adBanner.rootViewController = self;
        [self.adBanner loadRequest:request];
        
    } else {
        _adBanner.hidden = YES;
    }
    
    DictDetailViewController *vnViewController = [[DictDetailViewController alloc] initWithNibName:@"DictDetailViewController" bundle:nil];
    vnViewController.dictType = DictVietnam;
    vnViewController.wordObj = _wordObj;
    vnViewController.title = @"VN";
    
    DictDetailViewController *enViewController = [[DictDetailViewController alloc] initWithNibName:@"DictDetailViewController" bundle:nil];
    enViewController.dictType = DictEnglish;
    enViewController.wordObj = _wordObj;
    enViewController.title = @"EN";
    
    DictDetailViewController *lazzyViewController = [[DictDetailViewController alloc] initWithNibName:@"DictDetailViewController" bundle:nil];
    lazzyViewController.dictType = DictLazzyBee;
    lazzyViewController.wordObj = _wordObj;
    lazzyViewController.title = @"Lazzy Bee";
    
    NSArray *viewControllers = @[vnViewController, enViewController, lazzyViewController];
    
    tabViewController = [[MHTabBarController alloc] init];
    
    tabViewController.delegate = (id)self;
    tabViewController.viewControllers = viewControllers;
    
    CGRect rect;

    if (enableAds) {
        rect = self.view.frame;
        rect.size.height = _adBanner.frame.origin.y;
    } else {
        rect = self.view.frame;
    }
    
    [tabViewController.view setFrame:rect];
    
    tabViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                                UIViewAutoresizingFlexibleHeight |
                                                UIViewAutoresizingFlexibleLeftMargin |
                                                UIViewAutoresizingFlexibleRightMargin |
                                                UIViewAutoresizingFlexibleBottomMargin |
                                                UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:tabViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showActionsPanel {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:(id)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add to learn", nil];

    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSLog(@"Add to learn");
        //update queue value to 3 to consider this word as a new word in DB
        _wordObj.queue = [NSString stringWithFormat:@"%d", QUEUE_NEW_WORD];
        
        if (_wordObj.isFromServer) {
            [[CommonSqlite sharedCommonSqlite] insertWordToDatabase:_wordObj];
            
            //because word-id is blank so need to get again after insert it into db
            _wordObj = [[CommonSqlite sharedCommonSqlite] getWordInformation:_wordObj.question];
            
            [[CommonSqlite sharedCommonSqlite] addAWordToStydyingQueue:_wordObj];
            
        } else {
            [[CommonSqlite sharedCommonSqlite] addAWordToStydyingQueue:_wordObj];
            
            //remove from buffer
            [[CommonSqlite sharedCommonSqlite] removeWordFromBuffer:_wordObj];
            
            [[CommonSqlite sharedCommonSqlite] updateWord:_wordObj];
        }
        
        //update incomming list
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
        
    } else if (buttonIndex == 1) {
        
        NSLog(@"Cancel");
    }
}
@end
