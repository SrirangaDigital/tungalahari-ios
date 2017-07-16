//
//  AlbumViewController.m
//  Tungalahari
//
//  Created by sagar ayi on 11/07/17.
//  Copyright © 2017 srirangadigital. All rights reserved.
//

#import "AlbumViewController.h"
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
    
    Song * song = [_listOfSongs objectAtIndex:indexPath.row];
    [serialNumber setText:[NSString stringWithFormat:@"%d.",indexPath.row+1]];
    [songTitle setText:song.songTitle];
    [songDuration setText:song.songDuration];
    
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
