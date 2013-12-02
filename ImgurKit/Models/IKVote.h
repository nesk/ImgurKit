//
//  IKGalleryAlbum.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 23/08/13.
//  Distributed under the MIT license.
//

// Not using NS_ENUM for backward compatibility with OS X 10.7
typedef enum {
    IKDownVote      = -1,
    IKNeutralVote   = 0,
    IKUpVote        = 1
} IKVote;