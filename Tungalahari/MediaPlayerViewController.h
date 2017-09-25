//
//  MediaPlayerViewController.h
//  Tungalahari
//
//  Created by sagar ayi on 11/07/17.
//  Copyright © 2017 srirangadigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MediaPlayerViewController : UIViewController<AVAudioPlayerDelegate>{
    NSTimer *timer;
    NSData *audioData;
    NSString *filepath;
    NSMutableArray *mutableDataArray;
}
//Song detail properties
@property (strong, nonatomic) AVPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) NSString *songDetails;
@property (strong, nonatomic) NSString *songURL;
@property (strong, nonatomic) NSString *lyricsLink;
@property (strong, nonatomic) NSString *totalDuration;
@property (strong, nonatomic) NSString *ID;


@property (weak, nonatomic) IBOutlet UIImageView *displayimageView;

@property (weak,nonatomic) UIImage *albumart;

@property UIActivityIndicatorView * activityView;
@property UIActivityIndicatorView * activityIndicator;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;

@property (weak, nonatomic) IBOutlet UILabel *musicDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButtonText;
@property (weak, nonatomic) IBOutlet UIWebView *lyricsWebView;

- (IBAction)downloadSongAction:(id)sender;
- (IBAction)playPauseButton:(id)sender;
@end
