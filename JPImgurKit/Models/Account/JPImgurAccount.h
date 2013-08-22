//
//  JPImgurAccount.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 10/07/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface JPImgurAccount : NSObject

@property (nonatomic, readonly) NSUInteger accountID;

@property (nonatomic, readonly) NSString *url;
@property (nonatomic) NSString *bio;

@property (nonatomic, readonly) float reputation;
@property (nonatomic, readonly) NSDate *created;

#pragma mark - Load

+ (void)accountWithUsername:(NSString *)username success:(void (^)(JPImgurAccount *account))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (instancetype)initWithJSONObject:(NSData *)data;

@end
