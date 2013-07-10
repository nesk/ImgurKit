//
//  JPImgurGalleryImage.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Copyright (c) 2013 Johann PARDANAUD. All rights reserved.
//

#import "JPImgurImage.h"

@interface JPImgurGalleryImage : JPImgurImage

@property (readonly) NSString *accountURL;

@property (readonly) NSInteger ups;
@property (readonly) NSInteger downs;
@property (readonly) NSInteger score;

@property NSInteger vote; // -1 = downvote, +1 = upvote, 0 = user hasn't vote yet

@end
