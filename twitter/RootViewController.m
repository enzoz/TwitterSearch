//
//  RootViewController.m
//  twitter
//
//  Created by Enzo Zuccolotto on 6/15/11.
//  Copyright 2011 Universidade do Vale do Rio dos Sinos. All rights reserved.
//

#import "RootViewController.h"
#import "SearchResultView.h"

@implementation RootViewController

-(void)setupSearchButton{
    search = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    
    [search setFrame:CGRectMake(0, 0, 300, 45)];
    [search setTitle:@"Search" forState:UIControlStateNormal];
    [search setTag:10];
    
    [search addTarget:self action:@selector(searchButtonPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
}

-(void)setupQueryField{
    field = [[UITextField alloc] initWithFrame:CGRectMake(70, 12, 200, 30)];
    [field setHighlighted:YES];
    [field setTag:11];
}

- (void)viewDidLoad
{
    [self setupSearchButton];
    [self setupQueryField];
    
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];


    if(indexPath.section == 1)
    {
        [cell.contentView addSubview:search];
    }else
    {
        [cell.textLabel setText:@"Query"];
        [cell.contentView addSubview:field];
    }   
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell autorelease];
    return cell;
}


// Action to navigate to result view and search tweets
- (IBAction)searchButtonPressed:(id)sender
{   

    NSString *trimmedString = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
    
    if(trimmedString == nil || [trimmedString isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter a valid content." delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else
    {
        SearchResultView *searchResult = [[SearchResultView alloc] initWithNibName:@"SearchResultView" bundle:[NSBundle mainBundle]];
        searchResult.queryParam = field.text;
        [self.navigationController pushViewController:searchResult animated:YES];
        [searchResult release];
    }      
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (void)dealloc
{
    [field release];
    [search release];
    field = nil;
    
    [super dealloc];
}

@end
