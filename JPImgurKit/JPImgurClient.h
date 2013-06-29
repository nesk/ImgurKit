//
//  JPImgurClient.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 29/06/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>
#import "AFOAuth2Client.h"

@interface JPImgurClient : AFOAuth2Client

+ (instancetype)sharedInstanceWithBaseURL:(NSURL *)url ClientID:(NSString *)clientID secret:(NSString *)secret;
+ (instancetype)sharedInstanceWithClientID:(NSString *)clientID secret:(NSString *)secret;

- (NSURL *)getAuthorizationURLUsingPIN;
- (void)authenticateUsingOAuthWithPIN:(NSString *)pin success:(void (^)(AFOAuthCredential *))success failure:(void (^)(NSError *))failure;

@end