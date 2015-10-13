//
//  StudiedListViewController.h
//  LazzyBee
//
//  Created by HuKhong on 8/21/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    List_Unknown = 0,
    List_Incomming,
    List_StudiedList,
    List_SearchHint,
    List_SearchResult,
    List_Max
} SCREEN_TYPE;

@interface StudiedListViewController : UIViewController
{
    IBOutlet UILabel *lbHeaderInfo;
    IBOutlet UITableView *wordsTableView;
    
}

@property (nonatomic, assign) SCREEN_TYPE screenType;
@property (nonatomic, strong) NSString *searchText;     //use for search hint and search result

- (void)tableReload;
@end
