//
//  JPImgurGalleryAlbum.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Copyright (c) 2013 Johann PARDANAUD. All rights reserved.
//

#import "JPImgurAlbum.h"

@interface JPImgurGalleryAlbum : JPImgurAlbum

@property (nonatomic, readonly) NSInteger ups;
@property (nonatomic, readonly) NSInteger downs;
@property (nonatomic, readonly) NSInteger score;

@property (nonatomic) NSInteger vote; // -1 = downvote, +1 = upvote, 0 = user hasn't vote yet

@end