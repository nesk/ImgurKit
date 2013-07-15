//
//  JPImgurClient.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 29/06/13.
//  Distributed under the MIT license.
//

#import "JPImgurClient.h"
#import "AFOAuth2Client.h"

NSString * const JPBaseURL = @"https://api.imgur.com/3/";
NSString * const JPOAuthBaseURL = @"https://api.imgur.com/oauth2/";

@implementation JPImgurClient

- (id)init
{
    return [super initWithBaseURL:[NSURL URLWithString:JPBaseURL]];
}

- (instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret
{
    self = [self init];
    
    [self initializeOAuthWithClientID:clientID secret:secret];
    
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret
{
    self = [self initWithBaseURL:url];
    
    [self initializeOAuthWithClientID:clientID secret:secret];
    
    return self;
}

- (void)initializeOAuthWithClientID:(NSString *)clientID secret:(NSString *)secret
{
    if(!oauthClient)
        oauthClient = [[AFOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:JPOAuthBaseURL] clientID:clientID secret:secret];
}

- (NSURL *)getAuthorizationURLUsingPIN
{
    if(!oauthClient)
        @throw [NSException exceptionWithName:@"MissingResourceException" reason:@"The OAuth Client must be initialized to use this method" userInfo:nil];
    
    NSString *path = [NSString stringWithFormat:@"authorize?response_type=pin&client_id=%@", oauthClient.clientID];
    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:JPOAuthBaseURL]];
}

- (void)authenticateUsingOAuthWithPIN:(NSString *)pin success:(void (^)(AFOAuthCredential *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionary];
    [mutableParameters setObject:@"pin" forKey:@"grant_type"];
    [mutableParameters setValue:pin forKey:@"pin"];
    NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
    
    [oauthClient authenticateUsingOAuthWithPath:@"token" parameters:parameters success:success failure:failure];
}

@end