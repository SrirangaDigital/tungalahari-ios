//
//  AlbumViewController.h
//  Tungalahari
//
//  Created by sagar ayi on 11/07/17.
//  Copyright © 2017 srirangadigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "MediaPlayerViewController.h"

@interface AlbumViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property Album * album;
//song properties to pass
@property (strong,nonatomic) NSString *songDetailsToPass;
@property (strong, nonatomic) NSString *songURLToPass;
@property (strong, nonatomic) NSString *lyricsLinkToPass;
@property (strong, nonatomic) NSString *totalDuration;
@property (weak, nonatomic) IBOutlet UILabel *serialnumber;
@property (weak, nonatomic) IBOutlet UILabel *songduration;
@property (weak, nonatomic) IBOutlet UILabel *songdetails;
@property (strong, nonatomic) UIImage *albumArtToPass;
@property (weak, nonatomic) IBOutlet UILabel *songtitle;
@property (strong, nonatomic) NSString *albumidToPass;
@end
