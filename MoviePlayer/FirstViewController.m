//
//  FirstViewController.m
//  MoviePlayer
//
//  Created by Fr@nk on 30/08/12.
//  Copyright (c) 2012 Fr@nk. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self showMovie];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


/******** MoviePlayer methods ********/


- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    moviePlayer = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:moviePlayer];
    
    //NSLog(@"moviePlayBackDidFinish");
    
    if ([moviePlayer
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [moviePlayer.view removeFromSuperview];
    }
}



- (void)willEnterFullscreen:(NSNotification*)notification {
    NSLog(@"willEnterFullscreen");
}

- (void)enteredFullscreen:(NSNotification*)notification {
    NSLog(@"enteredFullscreen");
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
}

- (void)willExitFullscreen:(NSNotification*)notification {
    NSLog(@"willExitFullscreen");
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}



- (void)exitedFullscreen:(NSNotification*)notification {
    NSLog(@"exitedFullscreen");
    [moviePlayer.view removeFromSuperview];
    moviePlayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
}



- (void)playbackFinished:(NSNotification*)notification {
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackFinished. Reason: Playback Ended");
            [moviePlayer.view removeFromSuperview];
            moviePlayer = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"playbackFinished. Reason: Playback Error");
            [moviePlayer.view removeFromSuperview];
            moviePlayer = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackFinished. Reason: User Exited");
            [moviePlayer.view removeFromSuperview];
            moviePlayer = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self];
               
            break;
        default:
            break;
    }
    [moviePlayer setFullscreen:NO animated:YES];
    
    
    //NSLog(@"release");
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    
}


- (void)doneButtonPressed {
    // open a thread
    //NSLog(@"DoubleClicked.n");
    
    // Remove observer
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:nil];
    
    if([moviePlayer respondsToSelector:@selector(loadState)])
    {
        [[moviePlayer view] removeFromSuperview];
    }
    
    [moviePlayer stop];
    [moviePlayer release];
    
    [super dealloc];
    
    
}


- (IBAction)showMovie {
    
    NSURL* movieURL =  [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"]];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieReady:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
    moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    
    moviePlayer.view.frame = self.view.frame;
    [self.view addSubview:moviePlayer.view];
    
    
    [moviePlayer play];
    [moviePlayer setFullscreen:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    
}


/**************************************/






@end
