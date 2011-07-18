//
//  SearchResultView.m
//  twitter
//
//  Created by Enzo Zuccolotto on 6/15/11.
//  Copyright 2011 Universidade do Vale do Rio dos Sinos. All rights reserved.
//

#import "SearchResultView.h"
#import "MBProgressHUD.h"
#import "AsyncImageView.h"
#import "JSON.h"

@implementation SearchResultView


@synthesize queryParam;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Connection lifecycle

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (data != nil) {
        [data release];
        data = nil;
    }
    data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newdata
{
    [data appendData:newdata];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];        
    NSDictionary *results = [[stringData JSONValue] retain];
    [stringData release];    
    tweets = [results objectForKey:@"results"];

    [self.tableView reloadData];
    
    [HUD hide:YES];
}


#pragma mark - Loading data from Twitter
-(void)loadDataFromTwitter
{
    NSString *twitterSearchURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterSearchURL"];
    
    NSMutableString *searchURL = [[NSMutableString alloc] initWithString:twitterSearchURL];
    [searchURL appendString:queryParam]; 
    
    twitterSearchURL = [searchURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:twitterSearchURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    [self loadDataFromTwitter];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tweets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    
    NSDictionary *tweet = [tweets objectAtIndex:indexPath.row];
    
    AsyncImageView *imgView = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        
        imgView = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [imgView setTag:10];
        [cell.contentView addSubview:imgView];
        
        [cell.imageView setImage:[UIImage imageNamed:@"photo.png"]];
    } else {
        imgView = (AsyncImageView *) [cell.contentView viewWithTag:10];
    }
    
    [cell.textLabel setText:[tweet objectForKey:@"text"]];
    
    NSString *name = [tweet objectForKey:@"from_user"];
    
    [cell.detailTextLabel setText:name];
    
    NSString *photo = [tweet objectForKey:@"profile_image_url"];
    
    [imgView loadFromUrl:photo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *v = [cell.contentView viewWithTag:10];
    [cell.contentView bringSubviewToFront:v];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}


#pragma mark - HUD loading view
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}


@end
