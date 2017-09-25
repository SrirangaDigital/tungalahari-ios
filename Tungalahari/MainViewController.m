//
//  ViewController.m
//  Tungalahari
//
//  Created by sagar ayi on 11/07/17.
//  Copyright © 2017 srirangadigital. All rights reserved.
//

#import "MainViewController.h"
#import "Album.h"
#import "AlbumViewController.h"
#import <QuartzCore/QuartzCore.h>

#define cellIdentifier @"albumCell"
@interface MainViewController ()
@property NSArray * listOfAlbums;

@property Album * selectedAlbum;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ self.navigationController.navigationBar setBarTintColor :
            [UIColor colorWithRed:0.83 green:0.18 blue:0.18 alpha:1.0]];
    self.navigationItem.title = @"Tungalahari";
    [self initData];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];

//    _listOfAlbums = @[@"album_009",@"album_010",@"album_005",
//                      @"album_003",@"album_004",@"album_011",
//                      @"album_001",@"album_002"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initData
{
    NSArray * fileContents = [[self fetchContentsFromFile] objectForKey:@"albums"];
    NSMutableArray * albums = [[NSMutableArray alloc]init];
    
    for(NSDictionary * file in fileContents)
    {
        Album * album = [[Album alloc]init];
        album.albumId = [file objectForKey:@"id"];
        album.albumTitle = [file objectForKey:@"title"];
        album.numberOfSongs = [file objectForKey:@"numOfSongs"];
        
        [albums addObject:album];
    }
    _listOfAlbums = albums;
    
}

- (NSDictionary *) fetchContentsFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"albums" ofType:@"json"];
//                                                inDirectory:@"Data"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _listOfAlbums.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat displayWidth = screenWidth/2 - (1.35* (screenWidth/32));
//    CGFloat screenHeight = screenRect.size.height;
//    (CGRectGetWidth(self.view.frame)/2) + 3*(CGRectGetWidth(self.view.frame)/32)
    return CGSizeMake(displayWidth, (CGRectGetHeight(self.view.frame))/3 );
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0].CGColor;
    
    Album * album = [_listOfAlbums objectAtIndex:indexPath.row];
    
    UIImageView *albumImageView = (UIImageView *)[cell viewWithTag:100];
    albumImageView.image = [UIImage imageNamed:album.albumId];
    UILabel * albumTitle = (UILabel*)[cell viewWithTag:101];
    albumTitle.text = [NSString stringWithFormat:@"%@",album.albumTitle];
    UILabel * albumNoOfSongs = (UILabel*)[cell viewWithTag:102];
    albumNoOfSongs.text =  [NSString stringWithFormat:@"%@ songs",album.numberOfSongs ];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedAlbum = [_listOfAlbums objectAtIndex:indexPath.row];
   [self performSegueWithIdentifier:@"albumSegue" sender:self];
    
    
}


#pragma mark Collection view layout things

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 5.0;
//}
////
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 2.0;
//}
//
//// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,8,8,8);  // top, left, bottom, right
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"albumSegue" ])
     {
         AlbumViewController * albumVC = [segue destinationViewController];
         albumVC.album = _selectedAlbum;
     }
     
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
@end
