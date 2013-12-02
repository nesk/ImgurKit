//
//  IKClient.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 29/06/13.
//  Distributed under the MIT license.
//

#import "AFHTTPClient.h"
#import "AFOAuth2Client.h"
#import "AFHTTPRequestOperation.h"

// Not using NS_ENUM for backward compatibility with OS X 10.7
typedef enum {
    IKTokenAuthType,
    IKPINAuthType,
    IKCodeAuthType
} IKAuthType;

@interface IKClient : AFHTTPClient

@property (nonatomic) NSInteger retryCountOnImgurError; // Default: 3 (= 1 initial request + 3 retries)

@property (readonly, nonatomic) AFOAuth2Client *oauthClient;
@property (readonly, nonatomic) NSString *clientID;
@property (readonly, nonatomic) NSString *secret;

#pragma mark - Initialize

+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceWithClientID:(NSString *)clientID secret:(NSString *)secret;
+ (instancetype)sharedInstanceWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret;

- (instancetype)initWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret;

#pragma mark - Authenticate

- (NSURL *)authorizationURLUsing:(IKAuthType)authType;
- (void)authenticateUsingOAuthWithPIN:(NSString *)pin success:(void (^)(AFOAuthCredential *credentials))success failure:(void (^)(NSError *error))failure;
- (void)setAuthorizationHeaderWithToken:(NSString *)token;

#pragma mark - Manage the requests

// This method is overwritten to manage Imgur overloads or internal errors. Basically, it just retries to send the request a number of times defined by the `retryCountOnImgurError` property when an error 500 occurs.
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *, id))success
                                                    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *, id))success
                                                    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
                                                   andRetry:(NSInteger)retryCount;

@end
