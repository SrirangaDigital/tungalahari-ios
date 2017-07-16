//
//  Song.h
//  Tungalahari
//
//  Created by sagar ayi on 16/07/17.
//  Copyright © 2017 srirangadigital. All rights reserved.
//
/*
 Template
 "id" : "song_002",
 "title" : "Śrī Śāradāśataślōkī\nVedābhyāsa Jaḍōpi",
 "writer" : "Śrī Saccidānanda Śivābhinava Nṛsiṃha Bhāratī Mahāsvāmigaḷ",
 "duration" : "3:11"
 */
#import <Foundation/Foundation.h>
#import "Album.h"
@interface Song : NSObject

@property NSString * songID ;
@property NSString * songTitle;
@property NSString * songWriter;
@property NSString * songDuration;
@property Album * songAlbum;

@end
