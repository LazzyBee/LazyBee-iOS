//
//  StudiedListViewController.m
//  LazzyBee
//
//  Created by HuKhong on 8/21/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import "StudiedListViewController.h"
#import "StudiedTableViewCell.h"
#import "CommonSqlite.h"
#import "Common.h"
#import "StudyWordViewController.h"
#import "TagManagerHelper.h"
#import "SVProgressHUD.h"

@interface StudiedListViewController ()
{
    NSMutableDictionary *levelsDictionary;
    NSMutableArray *wordList;
    NSArray *keyArr;
}
@end

@implementation StudiedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_screenType == List_Incomming) {
        [TagManagerHelper pushOpenScreenEvent:@"iIncommingScreen"];
        
        [self setTitle:@"Incomming List"];
        
    } else if (_screenType == List_StudiedList) {
        [TagManagerHelper pushOpenScreenEvent:@"iLeantScreen"];
        
        [self setTitle:@"Learnt List"];
        
    } else if (_screenType == List_SearchHint) {
        [TagManagerHelper pushOpenScreenEvent:@"iSearchHintScreen"];
        
    } else if (_screenType == List_SearchResult) {
        [TagManagerHelper pushOpenScreenEvent:@"iSearchResultScreen"];
        
        [self setTitle:@"Search Result"];
    }
    
    levelsDictionary = [[NSMutableDictionary alloc] init];
    wordList = [[NSMutableArray alloc] init];
    
    [self tableReload];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshList)
                                                 name:@"refreshList"
                                               object:nil];
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

#pragma mark data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (_screenType == List_StudiedList ||
        _screenType == List_SearchHint ||
        _screenType == List_SearchResult) {
        return [[levelsDictionary allKeys] count];
        
    } else {
        
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_screenType == List_StudiedList ||
        _screenType == List_SearchHint ||
        _screenType == List_SearchResult) {
        NSString *headerTitle = @"";
        
        if (section < [keyArr count]) {
            NSString *key = [keyArr objectAtIndex:section];
            
            headerTitle = [NSString stringWithFormat:@"Level %@: %ld word(s)", key, [[levelsDictionary objectForKey:key] count]];
        }
        
        return headerTitle;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (_screenType == List_StudiedList ||
       _screenType == List_SearchHint ||
       _screenType == List_SearchResult) {
        
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        
        header.textLabel.textColor = [UIColor whiteColor];
        header.textLabel.font = [UIFont boldSystemFontOfSize:15];
        CGRect headerFrame = header.frame;
        header.textLabel.frame = headerFrame;
        header.textLabel.textAlignment = NSTextAlignmentLeft;
        
        header.backgroundView.backgroundColor = [UIColor darkGrayColor];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    if (_screenType == List_StudiedList ||
        _screenType == List_SearchHint ||
        _screenType == List_SearchResult) {
        
        if (section < [keyArr count]) {
            NSString *key = [keyArr objectAtIndex:section];
            
            return [[levelsDictionary objectForKey:key] count];
        } else {
            return 0;
        }
        
    } else {
        return [wordList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *studiedCellIdentifier = @"StudiedTableViewCell";
    
    StudiedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studiedCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudiedTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    WordObject *wordObj = nil;
    
    if (_screenType == List_StudiedList ||
        _screenType == List_SearchHint ||
        _screenType == List_SearchResult) {
        NSString *key = [keyArr objectAtIndex:indexPath.section];
        
        NSArray *arrWords = [levelsDictionary objectForKey:key];
        wordObj = [arrWords objectAtIndex:indexPath.row];
        
    } else {
        wordObj = [wordList objectAtIndex:indexPath.row];
    }
    
    //parse the answer to dictionary object
    NSData *data = [wordObj.answers dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictAnswer = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *strPronounciation = [dictAnswer valueForKey:@"pronoun"];
    
    //A word may has many meanings corresponding to many fields (common, it, economic...)
    //The meaning of each field is considered as a package
    NSDictionary *dictPackages = [dictAnswer valueForKey:@"packages"];
    NSDictionary *dictSinglePackage = [dictPackages valueForKey:@"common"];
    //"common":{"meaning":"", "explain":"<p>The edge of something is the part of it that is farthest from the center.</p>", "example":"<p>He ran to the edge of the cliff.</p>"}}
    
    NSString *strMeaning = [dictSinglePackage valueForKey:@"meaning"];
//    strMeaning = [[Common sharedCommon] stringByRemovingHTMLTag:strMeaning];
    
    cell.lbWord.text = wordObj.question;
    cell.lbPronounce.text = strPronounciation;
//    cell.lbMeaning.text = strMeaning;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[strMeaning dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    cell.lbMeaning.attributedText = attributedString;
    cell.lbMeaning.font = [UIFont systemFontOfSize:15];
    return cell;
}

#pragma mark table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WordObject *wordObj = nil;
    
    if (_screenType == List_StudiedList ||
        _screenType == List_SearchHint ||
        _screenType == List_SearchResult) {
        NSString *key = [keyArr objectAtIndex:indexPath.section];
        
        NSArray *arrWords = [levelsDictionary objectForKey:key];
        wordObj = [arrWords objectAtIndex:indexPath.row];
        
    } else {
        wordObj = [wordList objectAtIndex:indexPath.row];
    }
    
    if (_screenType == List_SearchHint) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectRowFromSearch" object:wordObj];
        
    } else {
        StudyWordViewController *studyViewController = [[StudyWordViewController alloc] initWithNibName:@"StudyWordViewController" bundle:nil];
        studyViewController.isReviewScreen = YES;
        studyViewController.wordObj = wordObj;
        
        [self.navigationController pushViewController:studyViewController animated:YES];
    }

}

- (void)tableReload {
    [wordList removeAllObjects];
    [levelsDictionary removeAllObjects];
    
    if (_screenType == List_Incomming) {
        [wordList addObjectsFromArray:[[CommonSqlite sharedCommonSqlite] getIncommingList]];
        
    } else if (_screenType == List_StudiedList) {
        [wordList addObjectsFromArray:[[CommonSqlite sharedCommonSqlite] getStudiedList]];
        
    } else if (_screenType == List_SearchHint) {
        [wordList addObjectsFromArray:[[CommonSqlite sharedCommonSqlite] getSearchHintList:_searchText]];
        
        if ([wordList count] == 0) {
            [self.view removeFromSuperview];
        }
        
    } else if (_screenType == List_SearchResult) {
        [wordList addObjectsFromArray:[[CommonSqlite sharedCommonSqlite] getSearchResultList:_searchText]];
        
        if ([wordList count] == 0) {
            [self searchOnServer];
        }
    }
    
    if (_screenType != List_Incomming) {
        //group by level
        for (WordObject *wordObj in wordList) {
            NSMutableArray *arr = [levelsDictionary objectForKey:wordObj.level];
            
            if (arr == nil) {
                arr = [[NSMutableArray alloc] init];
            }
            [arr addObject:wordObj];
            
            [levelsDictionary setObject:arr forKey:wordObj.level];
        }
        
        keyArr = [levelsDictionary allKeys];
        keyArr = [keyArr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    lbHeaderInfo.text = [NSString stringWithFormat:@"Total: %lu", (unsigned long)[wordList count]];
        
    
    [wordsTableView reloadData];
}

- (void)refreshList {
    if (_screenType == List_Incomming) {
        [self tableReload];
    }
}

- (void)searchOnServer {
    static GTLServiceDataServiceApi *service = nil;
    if (!service) {
        service = [[GTLServiceDataServiceApi alloc] init];
        service.retryEnabled = YES;
        //[GTMHTTPFetcher setLoggingEnabled:YES];
    }
    
    [SVProgressHUD showWithStatus:nil];
    GTLQueryDataServiceApi *query = [GTLQueryDataServiceApi queryForGetVocaByQWithQ:_searchText];
    //TODO: Add waiting progress here
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLDataServiceApiVoca *object, NSError *error) {
        if (object != nil){
            NSLog(object.JSONString);
            //TODO: Update word: q, a, level, package, (and ee, ev)
            WordObject *wordObj = [[WordObject alloc] init];
            wordObj.question   = object.q;
            wordObj.answers    = object.a;
            wordObj.level      = object.level;
            wordObj.package    = object.packages;
            wordObj.gid        = [NSString stringWithFormat:@"%@", object.gid];
            wordObj.langEN     = object.lEn;
            wordObj.langVN     = object.lVn;
            wordObj.package    = object.packages;
            wordObj.eFactor    = @"2500";
            wordObj.queue      = @"0";
            wordObj.isFromServer = YES;

            [wordList addObject:wordObj];
            
            //group by level
            for (WordObject *wordObj in wordList) {
                NSMutableArray *arr = [levelsDictionary objectForKey:wordObj.level];
                
                if (arr == nil) {
                    arr = [[NSMutableArray alloc] init];
                }
                [arr addObject:wordObj];
                
                [levelsDictionary setObject:arr forKey:wordObj.level];
                
                keyArr = [levelsDictionary allKeys];
                keyArr = [keyArr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            }
            
            lbHeaderInfo.text = [NSString stringWithFormat:@"Total: %lu", (unsigned long)[wordList count]];
            [wordsTableView reloadData];
            
            [SVProgressHUD dismiss];
            
        } else {
            [SVProgressHUD dismiss];
        }
    }];
}
@end
