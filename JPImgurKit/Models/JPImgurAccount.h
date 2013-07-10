//
//  JPImgurAccount.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 10/07/13.
//  Copyright (c) 2013 Johann PARDANAUD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPImgurAccount : NSObject

@property (nonatomic, readonly) NSUInteger accountID;

@property (nonatomic, readonly) NSString *url;
@property (nonatomic) NSString *bio;

@property (nonatomic, readonly) float reputation;
@property (nonatomic, readonly) NSString *created;

@end
