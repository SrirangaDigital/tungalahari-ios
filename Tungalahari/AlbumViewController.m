//
//  AlbumViewController.m
//  Tungalahari
//
//  Created by sagar ayi on 11/07/17.
//  Copyright © 2017 srirangadigital. All rights reserved.
//

#import "AlbumViewController.h"
#import "MediaPlayerViewController.h"
#import "Song.h"
#define cellIdentifier @"songCell"
@interface AlbumViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *albumArt;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property NSMutableArray * listOfSongs;
@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_albumTitle setText:_album.albumTitle];
    [_albumArt setImage:[UIImage imageNamed:_album.albumId]];
    [self fetchSongsInAlbum];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}



- (void)fetchSongsInAlbum
{
    _listOfSongs = [[NSMutableArray alloc]init];
    NSString * albumID = [[_album.albumId componentsSeparatedByString:@"_"]objectAtIndex:1];
    albumID = [NSString stringWithFormat:@"albumDetails_%@",albumID];
    
    NSDictionary * albumDetails = [[self fetchContentsFromFile:albumID] objectForKey:@"songs"];
    /*
     "id" : "song_001",
     "title" : "Invocatory verse from Śrī Ganēśa Stuti Mañjarī",
     "writer" : "Śrī Śrī Candraśēkhara Bhāratī Mahāsvāmigaḷ",
     "duration" : "1:31"
     */
    for(NSDictionary * songDetails in albumDetails)
    {
        Song * song = [[Song alloc]init];
        song.songID = [songDetails objectForKey:@"id"];
        song.songTitle = [songDetails objectForKey:@"title"];
        song.songWriter = [songDetails objectForKey:@"writer"];
        song.songDuration = [songDetails objectForKey:@"duration"];
        song.songAlbum = _album;
        
        [_listOfSongs addObject:song];
    }
    
}
- (NSDictionary *) fetchContentsFromFile:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
- (void)fetchSongData
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ _album.numberOfSongs integerValue];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel * serialNumber = (UILabel *)[cell viewWithTag:100];
    UILabel * songTitle = (UILabel *)[cell viewWithTag:101];
    UILabel * songDuration = (UILabel *)[cell viewWithTag:102];
    UILabel *songDetails = (UILabel *)[cell viewWithTag:103];

    Song * song = [_listOfSongs objectAtIndex:indexPath.row];
    
    [serialNumber setText:[NSString stringWithFormat:@"%ld.",indexPath.row+1]];
    [songTitle setText:song.songTitle];
    [songDuration setText:song.songDuration];

    
    if ([song.songWriter length] != 0)
    {
        [songDetails setText:[NSString stringWithFormat:@"%@",song.songWriter]];
    }
    else
    {
        songDetails.hidden = true;
        CGRect frame = cell.frame;
        NSLog(@"%f",frame.origin.x);
        
        
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Song * song = [_listOfSongs objectAtIndex:indexPath.row];
    self.albumidToPass = song.songAlbum.albumId;
    self.songDetailsToPass = [NSString stringWithFormat:@"%@\n%@",song.songTitle, song.songWriter];
    NSString * albumID = [[_album.albumId componentsSeparatedByString:@"_"] objectAtIndex:1];
    NSString *songID = [[song.songID componentsSeparatedByString:@"_"] objectAtIndex:1];
    self.songURLToPass = [NSString stringWithFormat:@"http://192.155.224.66/stage/files/tungalahari/128/%@/%@/index.mp3",albumID,songID];
    self.lyricsLinkToPass = [NSString stringWithFormat:@"Data/%@/%@",albumID, songID];
    self.totalDuration = song.songDuration;
    [self performSegueWithIdentifier:@"songSegue" sender:self];
    self.albumArtToPass = [UIImage imageNamed:_album.albumId];
    self.albumidToPass = albumID;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"songSegue"])
    {
        // Get reference to the destination view controller
        MediaPlayerViewController *mediaPlayer = [segue destinationViewController];
        mediaPlayer.ID = self.albumidToPass;
        mediaPlayer.songDetails = self.songDetailsToPass;
        mediaPlayer.songURL = self.songURLToPass;
        mediaPlayer.lyricsLink = self.lyricsLinkToPass;
        mediaPlayer.totalDuration = self.totalDuration;
    }
}


@end
