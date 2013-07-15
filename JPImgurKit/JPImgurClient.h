//
//  JPImgurClient.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 29/06/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@class AFOAuth2Client, AFOAuthCredential;

@interface JPImgurClient : AFHTTPClient
{
    AFOAuth2Client *oauthClient;
}

- (instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret;
- (instancetype)initWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret;

- (void)initializeOAuthWithClientID:(NSString *)clientID secret:(NSString *)secret;

- (NSURL *)getAuthorizationURLUsingPIN;
- (void)authenticateUsingOAuthWithPIN:(NSString *)pin success:(void (^)(AFOAuthCredential *))success failure:(void (^)(NSError *))failure;

- (void)setAuthorizationHeaderWithToken:(NSString *)token;

@end