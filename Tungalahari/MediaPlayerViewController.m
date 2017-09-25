//
//  MediaPlayerViewController.m
//  Tungalahari
//
//  Created by sagar ayi on 11/07/17.
//  Copyright © 2017 srirangadigital. All rights reserved.
//

#import "MediaPlayerViewController.h"

@interface MediaPlayerViewController ()

@end

@implementation MediaPlayerViewController
@synthesize slider, musicDetailsLabel, playPauseButtonText, lyricsWebView,endTime,startTime, activityIndicator, audioPlayer, displayimageView, activityView;

#pragma initial setup functions

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Intial Loading involves:
     1. Setup for playing audio in speaker
     2. Add activity indicator
     3. Set music details label
     4. Load lyrics webview
     */
    
    //1. for playing in the speaker
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                                           error:nil];
    
    timer = [[NSTimer alloc]init];
    
    activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    
    //3. Adding activity indicator
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setColor:[UIColor whiteColor]];
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    
    [activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [self.view addSubview:activityIndicator];
    _downloadButton.enabled = true;
    
    //4. Set initial details
    [musicDetailsLabel setText:self.songDetails];
    self.endTime.text = self.totalDuration;
    self.startTime.text = @"00:00";
    
    //5. Display webView Contents
    [self displayWebViewContents];
    
    //6. Display album art
    self.albumart = [UIImage imageNamed:self.ID];
    [displayimageView setImage:self.albumart];

    // initiate to zero until value is obtained
    self.slider.value = 0.0f;
    if( [ self isFileInFileSystem])
        _downloadButton.enabled = false;
    
    if([AVAudioSession sharedInstance]){
        dispatch_async(dispatch_get_main_queue(), ^{
            audioPlayer = nil;
            [audioPlayer pause];
            [[AVAudioSession sharedInstance] setActive:FALSE error:nil];
            [audioPlayer replaceCurrentItemWithPlayerItem:nil];
        });
    }
    
}
#pragma View appearance advance setup functions
- (void) initialPlayerSetup{
    
    // Stream song from URL if not in local storage

    NSError *error;
    audioPlayer =[[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.songURL]];
    [audioPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    audioPlayer.automaticallyWaitsToMinimizeStalling = false;
    if(!audioPlayer)
    {
        NSLog(@"Error creating player: %@", error);
    }
    self.startTime.text = @"00:00";
  
    self.slider.maximumValue = CMTimeGetSeconds(audioPlayer.currentItem.asset.duration);
    
    [activityIndicator stopAnimating];

}
- (void) viewWillDisappear:(BOOL)animated{
    [audioPlayer pause];
    [audioPlayer seekToTime:kCMTimeZero];
}
- (void)displayWebViewContents{
    
    NSString *albumID = [[ self.lyricsLink componentsSeparatedByString:@"/"] objectAtIndex:1];
    NSString *songID = [[ self.lyricsLink componentsSeparatedByString:@"/"] objectAtIndex:2];
    NSString *filePath = [NSString stringWithFormat:@"lyrics_%@_%@", albumID, songID];
    
    //3. Load the lyrics webview
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:filePath ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [lyricsWebView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Slider functions

// Slider Value change function
- (IBAction)sliderValueChanged:(id)sender
{
    [self updateSliderLabels];
    CMTime tm = CMTimeMake(slider.value, 1);
    [audioPlayer seekToTime:tm];
    [audioPlayer play];
}

- (void)updateSliderLabels
{
    NSTimeInterval currentTime = slider.value;
    NSString* currentTimeString = [self timeForTimeInterval:currentTime];
    startTime.text =  currentTimeString;
}

- (void)updateSlideToStop{
    [self stopTimer];
  //  [audioPlayer playAtTime:0];
    slider.value = 0.0f;
    startTime.text = @"00:00";
}

-(NSString* )timeForTimeInterval:(NSTimeInterval)timeInterval//Todo : work in progress
{
    NSString * displayTime;
    NSInteger  minutes= floor(timeInterval/60);
    NSInteger second = round(timeInterval - minutes * 60);
    if(second < 10 && minutes < 10)
        displayTime  = [NSString stringWithFormat:@"0%ld:0%ld",(long)minutes,(long)second];
    else{
        if(second < 10)
            displayTime  = [NSString stringWithFormat:@"%ld:0%ld",(long)minutes,(long)second];
        else if(minutes < 10)
            displayTime  = [NSString stringWithFormat:@"0%ld:%ld",(long)minutes,(long)second];
        else
            displayTime  = [NSString stringWithFormat:@"%ld:%ld",(long)minutes,(long)second];
    }
    return displayTime;
}

- (void)updateTime:(NSTimer *)timer {
    
    slider.value = CMTimeGetSeconds([audioPlayer currentTime]);
    NSString* currentTimeString = [self timeForTimeInterval:slider.value];
    self.startTime.text =  currentTimeString;
    if([startTime.text isEqualToString:@"00:00"])
        [playPauseButtonText setImage:[ UIImage imageNamed:@"play"] forState:UIControlStateNormal ];
}

- (void) updateDisplay{
    
    NSTimeInterval currentTime = CMTimeGetSeconds([audioPlayer currentTime]);
    NSString* currentTimeString = [self timeForTimeInterval:currentTime];
    
    slider.value = currentTime;
    [self updateSliderLabels];
    
    if(currentTime > 0)
        startTime.text = currentTimeString;
    
}

- (IBAction)playPauseButton:(id)sender {
    
    UIImage *play = [UIImage imageNamed:@"play"];
    
    activityView.center=self.view.center;
    
    if (audioPlayer.status != AVPlayerStatusReadyToPlay) {
        [activityView startAnimating];
    }
    
    [self.view addSubview:activityView];
    
    if([[playPauseButtonText imageForState:UIControlStateNormal] isEqual:play]){
        // Play Button Indication

        if([self isFileInFileSystem])
           audioData = [NSData dataWithContentsOfFile:filepath];
        
        if(!audioPlayer)
        { // Play from beginning
            
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(startFetching)
                                           userInfo:nil
                                            repeats:NO];
        }
        else
            [audioPlayer play];   // play from where it was left
        timer = [NSTimer
                     scheduledTimerWithTimeInterval:0.1
                     target:self selector:@selector(timerFired:)
                     userInfo:nil repeats:YES];
        [playPauseButtonText setImage:[ UIImage imageNamed:@"pause"] forState:UIControlStateNormal ];
        
    }
    else{
        [audioPlayer pause];
        [self stopTimer];
        [self updateDisplay];
        [playPauseButtonText setImage:[ UIImage imageNamed:@"play"] forState:UIControlStateNormal ];
    }
}

-(void)startFetching
{
    if(audioPlayer)
        [audioPlayer setRate:0.00];
    [activityIndicator stopAnimating];
    [self initialPlayerSetup];

    [audioPlayer play];
    timer = [NSTimer
             scheduledTimerWithTimeInterval:0.1
             target:self selector:@selector(timerFired:)
             userInfo:nil repeats:YES];
    
}

#pragma timer methods
- (void) timerFired:(NSTimer *)timer{
    [self updateDisplay];
}

- (void) stopTimer{
    
    [timer invalidate];
    timer = nil;
}

#pragma AVAudioPlayer delegate methods
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self stopTimer];
    [self updateDisplay];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
    [self stopTimer];
    [self updateDisplay];
}

#pragma Feature Button Actions
// Function that checks if file is a part of file system and returns a bool value
- (bool) isFileInFileSystem{
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *album = [[self.songURL componentsSeparatedByString:@"/"]objectAtIndex:7];
    NSString *songID = [[self.songURL componentsSeparatedByString:@"/"]objectAtIndex:8];
    NSString *filename = [NSString stringWithFormat:@"%@_%@_index.mp3",album,songID];
    
    filepath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,filename];
    bool exists = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    if(exists){
        audioData = [NSData dataWithContentsOfFile:filepath];
    }
    
    
    return exists;
}

// download song to file system
- (IBAction)downloadSongAction:(id)sender {
    
    [activityIndicator startAnimating];
    [audioPlayer pause];
    NSURL  *url = [NSURL URLWithString:self.songURL];
    NSData *urlData;
    if(audioData || [self isFileInFileSystem] )
        urlData = audioData;
    else
        urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *album = [[self.songURL componentsSeparatedByString:@"/"]objectAtIndex:7];
        NSString *songID = [[self.songURL componentsSeparatedByString:@"/"]objectAtIndex:8];
        NSString *filename = [NSString stringWithFormat:@"%@_%@_index.mp3",album,songID];
        filepath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,filename];
        [urlData writeToFile:filepath atomically:YES];
    }
    _downloadButton.enabled = false;
    [activityIndicator stopAnimating];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == audioPlayer && [keyPath isEqualToString:@"status"]) {
        if (audioPlayer.status == AVPlayerStatusReadyToPlay) {
            [activityView stopAnimating];
            [activityView removeFromSuperview];
        } else {
            [activityView startAnimating];
            // something went wrong. player.error should contain some information
        }
    }
}

@end
