//
//  SecondViewController.m
//  MoviePlayer
//
//  Created by Fr@nk on 30/08/12.
//  Copyright (c) 2012 Fr@nk. All rights reserved.
//

#import "SecondViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SecondViewController (PrivateMethods)
- (GDataServiceGoogleYouTube *)youTubeService;
@end


@implementation SecondViewController

@synthesize feed, videoURL, progressAlert, spinner, feedEntries;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}


- (void) waitForData {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
}



-(void) loadData{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    //HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    //[self.navigationController.view addSubview:HUD];
	
    //HUD.delegate = self;
    //HUD.labelText = NSLocalizedString(@"LOADING", nil);
    //HUD.detailsLabelText = NSLocalizedString(@"UPDATING_DATA", nil);
	//HUD.square = YES;
    
    
    GDataServiceGoogleYouTube *service = [self youTubeService];
    
    NSString *uploadsID = kGDataYouTubeUserFeedIDUploads;
    
    
    NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForUserID:@"ACUTOpuntoORG" userFeedID:uploadsID];
    
    GDataQueryYouTube* query = [GDataQueryYouTube  youTubeQueryWithFeedURL:  feedURL];
	[query setStartIndex:1];
	[query setMaxResults:25];
	
	[service fetchFeedWithQuery:query
					   delegate:self
			  didFinishSelector:@selector(request:finishedWithFeed:error:)];

}


/*- (void)showWithDetailsLabel {
 
 HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
 [self.navigationController.view addSubview:HUD];
 
 HUD.delegate = self;
 HUD.labelText = NSLocalizedString(@"CONNECTING_SERVER",nil);
 HUD.detailsLabelText = NSLocalizedString(@"PLEASE_WAIT", nil);
 //HUD.square = YES;
 
 [HUD showWhileExecuting:@selector(loadData) onTarget:self withObject:nil animated:YES];
 }
 */



- (void)viewDidLoad {
    //DLog(@"loading");
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"update_20"] style:UIBarButtonItemStylePlain target:self action:@selector(loadData)];
    
    //UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(loadData)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    
    /*
     GDataQueryYouTube* query = [GDataQueryYouTube  youTubeQueryWithFeedURL:feedURL];
     
     [query setVideoQuery:searchString];
     
     [query setMaxResults:5];
     [service fetchFeedWithQuery:query delegate:self didFinishSelector:@selector(entryListFetchTicket:finishedWithFeed:)];
     
     
     [service fetchFeedWithQuery:query delegate:self didFinishSelector:@selector(entryListFetchTicket:finishedWithFeed:)];
     
     */
    
    
    feedEntries = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    // [service fetchFeedWithURL:feedURL delegate:self didFinishSelector:@selector(request:finishedWithFeed:error:)];
    
    [super viewDidLoad];
    
    //primo thread (quello principale)
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self performSelectorOnMainThread:@selector(waitForData) withObject:nil waitUntilDone:NO];
    
    //secondo thread
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.25];
    
    
}

- (void)request:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedBase *)aFeed
          error:(NSError *)error {
    
    self.feed = (GDataFeedYouTubeVideo *)aFeed;
    
    [feedEntries removeAllObjects];
    
    for (GDataEntryBase *videoEntry in [feed entries]){
        
        //DLog(@"videoURL = %@",[[videoEntry title] stringValue] );
        NSString *title = [[[videoEntry title] stringValue]lowercaseString];
        
        if([title rangeOfString:@"long version"].location == NSNotFound){
            [feedEntries addObject:videoEntry];
        }
    }
    
    /*for (GDataEntryYouTubeVideo *videoEntry in [feed entries]) {
     
     GDataYouTubeMediaGroup *mediaGroup = [videoEntry mediaGroup];
     
     NSString *videoURLEmbed = @"http://www.youtube.com/embed/%@";
     NSString *videoID = [mediaGroup videoID];
     videoURL = [NSString stringWithFormat:videoURLEmbed, videoID];
     
     //DLog(@"videoURL = %@",videoURL);
     }*/
    
    //DLog(@"COUNT VIDEO: %d",[[feed entries]count]);
    
    [self.tableView reloadData];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}


- (GDataServiceGoogleYouTube *)youTubeService {
    static GDataServiceGoogleYouTube* _service = nil;
    
    if (!_service) {
        _service = [[GDataServiceGoogleYouTube alloc] init];
        
        [_service setUserAgent:@"AppWhirl-UserApp-1.0"];
        //[_service setShouldCacheDatedData:YES];
        [_service setServiceShouldFollowNextLinks:NO];
    }
    
    // fetch unauthenticated
    [_service setUserCredentialsWithUsername:nil
                                    password:nil];
    
    return _service;
}

- (void) launchVideo {
    
    // self.videoURL = @"http://youtube.com/embed/-0Xa4bHcJu8";
    
    youTubeViewController = [[[YouTubeViewController alloc] initWithNibName:nil bundle:nil] retain];
    
    youTubeViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    youTubeViewController.videoURL = self.videoURL;
    
    //[self presentModalViewController:youTubeViewController animated:YES];
    //[[self navigationController] pushViewController:youTubeViewController animated:YES];
    [self presentModalViewController:youTubeViewController animated:YES];
    
    [youTubeViewController release];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedEntries count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:.94 green:.96 blue:.99 alpha:1]];
    }
    else [cell setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell.
    GDataEntryBase *entry = [feedEntries objectAtIndex:indexPath.row];
    NSString *title = [[entry title] stringValue];
    NSArray *thumbnails = [[(GDataEntryYouTubeVideo *)entry mediaGroup] mediaThumbnails];
    
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 3; // 0 means no max.
    
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[thumbnails objectAtIndex:0] URLString]]];
    cell.imageView.image = [UIImage imageWithData:data];
    
    return cell;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}





- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    //DECOMMENT FOR TITLE
    /*
     GDataEntryBase *entry2 = [[feed entries] objectAtIndex:indexPath.row];
     NSArray *contents = [[(GDataEntryYouTubeVideo *)entry2 mediaGroup] mediaContents];
     NSString *vidTitle = [[entry2 title] stringValue];
     */
    
    
    GDataEntryYouTubeVideo *videoEntry = [feedEntries objectAtIndex:indexPath.row];
    
    GDataYouTubeMediaGroup *mediaGroup = [videoEntry mediaGroup];
    
    NSString *videoURLEmbed = @"http://www.youtube.com/embed/%@";
    NSString *videoID = [mediaGroup videoID];
    videoURLEmbed = [NSString stringWithFormat:videoURLEmbed, videoID];
    
    // DLog(@"videoURL = %@",videoURL);
    
    //DLog(@"URL = %@",[[contents objectAtIndex:0] URLString]);
    //self.videoURL = [[contents objectAtIndex:0] URLString];
    self.videoURL = videoURLEmbed;
    [self launchVideo];
    
    
}


- (void)dealloc {
    [super dealloc];
    [feedEntries dealloc];
    
}



@end