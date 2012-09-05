//
//  YouTubeViewController.m
//  YoutubeTest
//
//  Created by Francesco Ficetola on 09/04/12.
//  Copyright (c) 2012 __Cremisi__. All rights reserved.
//

#import "YouTubeViewController.h"
#import "GDataEntryYouTubeVideo.h"
#import "GDataServiceGoogleYoutube.h"

@implementation YouTubeViewController

@synthesize videoURL, videoHTML, videoView;

/*- (void)embedYouTube {
    
    videoHTML = [NSString stringWithFormat:@"\
                 <html>\
                 <head>\
                 <style type=\"text/css\">\
                 iframe {position:absolute; top:50%%; margin-top:-130px;}\
                 body {background-color:#000; margin:0;}\
                 </style>\
                 </head>\
                 <body>\
                 <iframe width=\"100%%\" height=\"240px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                 </body>\
                 </html>", videoURL];
    
    [videoView loadHTMLString:videoHTML baseURL:nil];
}*/


- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame {
    // webView is a UIWebView, either initialized programmatically or loaded as part of a xib.
    
   // NSString *embedHTML = @"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head><body style=\"background:black;margin-top:0px;margin-left:0px\"><div><object width=\"212\" height=\"172\"><param name=\"movie\" value=\"%@\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"%@\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"212\" height=\"172\"></embed></object></div></body></html>";
    
        
    //[self.view addSubview:videoView];
    
   
    /*[videoView loadHTMLString:videoHTML baseURL:nil];  
     */
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:videoURL];
    
       
    NSString *htmlString = nil;
    
    if([self interfaceOrientation] == UIInterfaceOrientationPortrait){
        htmlString = @"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 200\"/></head><body style=\"background:#000000;margin-top:70%;margin-left:0px;text-align:center;\"><div><iframe width=\"200\" height=\"200\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe></div></body></html>";
        
    }
    else {
        htmlString = @"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 200\"/></head><body style=\"background:#000000;margin-top:50%;margin-left:0px;text-align:center;\"><div><iframe width=\"200\" height=\"200\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe></div></body></html>";
        
    }
    
    
    htmlString = [NSString stringWithFormat:htmlString, url];
    
    videoView.delegate = self;
    
    [videoView loadHTMLString:htmlString baseURL:nil];
    
    [url release];

}




- (IBAction) closeModal {
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    videoView.backgroundColor = [UIColor blackColor];
    videoView.opaque = NO;
    
    //[self embedYouTube];
    [self embedYouTube:[NSURL URLWithString:videoURL] frame:CGRectMake(70, 100, 200, 200)];
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //[activityIndicator startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   // [activityIndicator stopAnimating];
	
}

- (void)myWebView:(UIWebView *)myWebView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=+5 color='red'>Occurring Error:<br/>%@</font></center></html>",
							 error.localizedDescription];
	[videoView loadHTMLString:errorString baseURL:nil];
}


-(void) viewDidAppear:(BOOL)animated{
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return YES;
}


@end
