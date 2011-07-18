//
//  RootViewController.h
//  twitter
//
//  Created by Enzo Zuccolotto on 6/15/11.
//  Copyright 2011 Universidade do Vale do Rio dos Sinos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {

    IBOutlet UIButton *search;
    IBOutlet UITextField *field;
}

- (IBAction)searchButtonPressed:(id)sender;


@end
