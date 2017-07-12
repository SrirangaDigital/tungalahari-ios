//
//  AlbumViewController.h
//  Tungalahari
//
//  Created by sagar ayi on 11/07/17.
//  Copyright © 2017 srirangadigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
@interface AlbumViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property Album * album;
@end
