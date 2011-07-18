//
//  SearchResultView.h
//  twitter
//
//  Created by Enzo Zuccolotto on 6/15/11.
//  Copyright 2011 Universidade do Vale do Rio dos Sinos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SearchResultView : UITableViewController <MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    
    NSMutableArray *tweets;
    NSMutableData *data;
    
}

@property (assign, nonatomic, readwrite)NSString *queryParam;

@end
