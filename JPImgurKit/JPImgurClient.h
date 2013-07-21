//
//  JPImgurClient.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 29/06/13.
//  Distributed under the MIT license.
//

#import "AFHTTPClient.h"

@class AFOAuth2Client, AFOAuthCredential;

@interface JPImgurClient : AFHTTPClient
{
    AFOAuth2Client *oauthClient;
}

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceWithBaseURL:(NSURL *)url;
+ (instancetype)sharedInstanceWithClientID:(NSString *)clientID secret:(NSString *)secret;
+ (instancetype)sharedInstanceWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret;

#pragma mark -

- (instancetype)initWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret;

#pragma mark -

- (void)initializeOAuthWithClientID:(NSString *)clientID secret:(NSString *)secret;

#pragma mark -

- (NSURL *)getAuthorizationURLUsingPIN;
- (void)authenticateUsingOAuthWithPIN:(NSString *)pin success:(void (^)(AFOAuthCredential *))success failure:(void (^)(NSError *))failure;
- (void)setAuthorizationHeaderWithToken:(NSString *)token;

@end