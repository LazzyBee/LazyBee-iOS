//
//  DictDetailViewController.m
//  LazzyBee
//
//  Created by HuKhong on 10/7/15.
//  Copyright © 2015 Born2go. All rights reserved.
//

#import "DictDetailViewController.h"
#import "HTMLHelper.h"
#import "Common.h"
#import "CommonDefine.h"

@interface DictDetailViewController ()

@end

@implementation DictDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.   
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *htmlString = @"";
    
    if (_wordObj) {
        if (_dictType == DictVietnam) {
            htmlString = [[HTMLHelper sharedHTMLHelper] createHTMLDict:_wordObj dictType:@"vn"];
            
        } else if (_dictType == DictEnglish) {
            htmlString = [[HTMLHelper sharedHTMLHelper] createHTMLDict:_wordObj dictType:@"en"];
            
        } else if (_dictType == DictLazzyBee) {
            NSString *curMajor = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:KEY_SELECTED_MAJOR];
            
            if (curMajor == nil || curMajor.length == 0) {
                curMajor = @"common";
            }
            
            htmlString = [[HTMLHelper sharedHTMLHelper]createHTMLForAnswer:_wordObj withPackage:curMajor];
        }
    }
    
    [webviewWord loadHTMLString:htmlString baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopPlaySoundOnWebview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)stopPlaySoundOnWebview {
    [webviewWord stringByEvaluatingJavaScriptFromString:@"cancelSpeech()"];
}
@end
