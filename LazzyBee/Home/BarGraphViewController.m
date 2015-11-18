//
//  BarGraphViewController.m
//  LazzyBee
//
//  Created by HuKhong on 11/17/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import "BarGraphViewController.h"
#import "CommonSqlite.h"
#import "WordObject.h"
#import "Common.h"
#import "PlaySoundLib.h"
#import "TagManagerHelper.h"

#define NUMBER_OF_DAYS 7
// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface BarGraphViewController ()
{
    NSMutableDictionary *levelsDictionary;
    NSMutableArray *wordList;
    NSArray *keyArr;
}
@end

@implementation BarGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TagManagerHelper pushOpenScreenEvent:@"iBarGraphView"];
    // Do any additional setup after loading the view from its nib.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [self.navigationController.navigationBar setTranslucent:NO];
    }
#endif
    [self.navigationController.navigationBar setBarTintColor:COMMON_COLOR];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self setTitle:@"Learning progress"];
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:(id)self  action:@selector(cancelButtonClick)];
    self.navigationItem.leftBarButtonItem = btnCancel;
    
    // Do any additional setup after loading the view from its nib.
    levelsDictionary = [[NSMutableDictionary alloc] init];
    wordList = [[NSMutableArray alloc] init];
    
    graphView.dataSource = (id)self;
    
    [self drawGraph];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    CGRect rect = scrollViewContainer.frame;
    
    rect.size.height = streakView.frame.origin.y + streakView.frame.size.height + 10;
    [scrollViewContainer setContentSize:rect.size];
    
    [self rotateImage:imgRingStreak duration:2.0
                curve:UIViewAnimationCurveLinear degrees:0];
    
    [[PlaySoundLib sharedPlaySoundLib] playFileInResource:@"magic.mp3"];
}

- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration
              curve:(int)curve degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:image cache:YES];
    // The transform matrix
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)cancelButtonClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)drawGraph {
    [wordList removeAllObjects];
    [levelsDictionary removeAllObjects];
    
    [wordList addObjectsFromArray:[[CommonSqlite sharedCommonSqlite] getStudiedList]];
    
    for (WordObject *wordObj in wordList) {
        NSMutableArray *arr = [levelsDictionary objectForKey:wordObj.level];
        
        if (arr == nil) {
            arr = [[NSMutableArray alloc] init];
        }
        [arr addObject:wordObj];
        
        [levelsDictionary setObject:arr forKey:wordObj.level];
    }
    
    keyArr = [levelsDictionary allKeys];
    
    [graphView draw];
    
    NSInteger streakCount = [[Common sharedCommon] getCountOfStreak];
    
    lbStreakCount.text = [NSString stringWithFormat:@"%ld day(s)", (long)streakCount];

}


#pragma mark - GKBarGraphDataSource

- (NSInteger)numberOfBars {
    return 6;
}

- (NSNumber *)valueForBarAtIndex:(NSInteger)index {
    NSInteger count = [[levelsDictionary objectForKey:[NSString stringWithFormat:@"%ld", (long)index +1]] count];
    count = (int)(count*100/[wordList count]);
    return [NSNumber numberWithInteger:count];
}

- (UIColor *)colorForBarAtIndex:(NSInteger)index {
    id colors = @[[UIColor gk_turquoiseColor],
                  [UIColor gk_peterRiverColor],
                  [UIColor gk_alizarinColor],
                  [UIColor gk_amethystColor],
                  [UIColor gk_emerlandColor],
                  [UIColor gk_sunflowerColor]
                  ];
    return [colors objectAtIndex:index];
}

//- (UIColor *)colorForBarBackgroundAtIndex:(NSInteger)index {
//    return [UIColor redColor];
//}

- (CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index {
    CGFloat percentage = [[self valueForBarAtIndex:index] doubleValue];
    percentage = (percentage / 100);
    return (graphView.animationDuration * percentage);
}

- (NSString *)titleForBarAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"lv %ld", (long)index + 1];
}

- (NSString *)valueLabelForBarAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%ld", [[levelsDictionary objectForKey:[NSString stringWithFormat:@"%ld", (long)index + 1]] count]];
}
@end
