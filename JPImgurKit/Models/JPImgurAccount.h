//
//  JPImgurAccount.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 10/07/13.
//  Copyright (c) 2013 Johann PARDANAUD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPImgurAccount : NSObject

@property (readonly) NSInteger accountId;

@property (readonly) NSString *url;
@property NSString *bio;

@property (readonly) float reputation;
@property (readonly) NSString *created;

@end
