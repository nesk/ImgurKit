//
//  JPImgurClient.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 29/06/13.
//  Distributed under the MIT license.
//

#import "JPImgurClient.h"
#import "AFOAuth2Client.h"

NSString * const BASE_URL = @"https://api.imgur.com/3/";

// This constant is necessary to avoid each path to start with `3/` and to allow OAuth requests to work, see overidden `authenticateUsingOAuthWithPath:parameters:success:failure:` method
NSString * const OAUTH_BASE_URL = @"https://api.imgur.com/oauth/";

@implementation JPImgurClient

+ (instancetype)sharedInstanceWithBaseURL:(NSURL *)url ClientID:(NSString *)clientID secret:(NSString *)secret
{
    static dispatch_once_t onceToken;
    static JPImgurClient *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithBaseURL:url clientID:clientID secret:secret];
    });
    return sharedInstance;
}

+ (instancetype)sharedInstanceWithClientID:(NSString *)clientID secret:(NSString *)secret
{
    return [self sharedInstanceWithBaseURL:[NSURL URLWithString:BASE_URL] ClientID:clientID secret:secret];
}

- (NSURL *)getAuthorizationURLUsingPIN
{
    NSString *path = [NSString stringWithFormat:@"authorize?response_type=pin&client_id=%@", self.clientID];
    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:OAUTH_BASE_URL]];
}

-(void)authenticateUsingOAuthWithPIN:(NSString *)pin success:(void (^)(AFOAuthCredential *))success failure:(void (^)(NSError *))failure
{
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:@"This method is currently not implemented" userInfo:nil];
}

@end