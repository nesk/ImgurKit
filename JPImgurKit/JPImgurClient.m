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
NSString * const JPOAuthBaseURL = @"https://api.imgur.com/oauth/";

@implementation JPImgurClient

- (id)init
{
    return [super initWithBaseURL:[NSURL URLWithString:JPBaseURL]];
}

- (instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret
{
    self = [self init];
    
    [self initializeOAuthModuleWithClientID:clientID secret:secret];
    
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret
{
    self = [self initWithBaseURL:url];
    
    [self initializeOAuthModuleWithClientID:clientID secret:secret];
    
    return self;
}

- (void)initializeOAuthModuleWithClientID:(NSString *)clientID secret:(NSString *)secret
{
    if(!oauthModule)
        oauthModule = [[AFOAuth2Client alloc] initWithBaseURL:[self baseURL] clientID:clientID secret:secret];
}

- (NSURL *)getAuthorizationURLUsingPIN
{
    if(!oauthModule)
        @throw [NSException exceptionWithName:@"MissingResourceException" reason:@"The OAuth module must initialized to use this method" userInfo:nil];
    
    NSString *path = [NSString stringWithFormat:@"authorize?response_type=pin&client_id=%@", oauthModule.clientID];
    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:JPOAuthBaseURL]];
}

- (void)authenticateUsingOAuthWithPIN:(NSString *)pin success:(void (^)(AFOAuthCredential *))success failure:(void (^)(NSError *))failure
{
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:@"This method is currently not implemented" userInfo:nil];
}

@end