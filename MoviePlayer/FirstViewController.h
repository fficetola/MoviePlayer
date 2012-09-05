//
//  FirstViewController.h
//  MoviePlayer
//
//  Created by Fr@nk on 30/08/12.
//  Copyright (c) 2012 Fr@nk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface FirstViewController : UIViewController{

    MPMoviePlayerController *moviePlayer;
    
}


- (IBAction)showMovie;

@end
