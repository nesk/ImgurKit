//
//  JPImgurKitFrameworkTests.m
//  JPImgurKitFrameworkTests
//
//  Created by Johann Pardanaud on 27/06/13.
//  Distributed under the MIT license.
//

#import "JPImgurKitTests.h"
#import "JPImgurKit.h"

#import "AFHTTPRequestOperation.h"
#import "AFOAuth2Client.h"

@implementation JPImgurKitTests

- (void)setUp
{
    [super setUp];
    
    NSDictionary *infos = [[NSBundle bundleForClass:[self class]] infoDictionary];
    
    NSString *clientID = [infos objectForKey:@"clientID"];
    NSString *clientSecret = [infos objectForKey:@"clientSecret"];
    NSString *accessToken = [infos objectForKey:@"accessToken"];
    
    client = [[JPImgurClient alloc] initWithClientID:clientID secret:clientSecret];
    STAssertNotNil(client, @"Cannot initialize the client object");
    
    [client setAuthorizationHeaderWithToken:accessToken];
}

- (dispatch_semaphore_t)enableAsyncTestingFirstStep
{
    return dispatch_semaphore_create(0);
}

- (void)enableAsyncTestingSecondStep:(dispatch_semaphore_t)semaphore
{
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)enableAsyncTestingThirdStep:(dispatch_semaphore_t)semaphore
{
    dispatch_semaphore_signal(semaphore);
}

- (void)testAuthorizationURLWithPIN
{
    NSURL *url = [client getAuthorizationURLUsingPIN];
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    
    [request start];
    [request waitUntilFinished];
    
    NSInteger status = [request.response statusCode];
    
    if(status != 200)
        STFail(@"Unexpected status code (%d) returned from URL `%@`", (int)status, [url absoluteString]);
}

- (void)testAuthenticateUsingOAuthWithPIN
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    [[NSWorkspace sharedWorkspace] openURL:[client getAuthorizationURLUsingPIN]];
    
    NSLog(@"Enter the code PIN");
    char pin[20];
    scanf("%s", pin);

    [client authenticateUsingOAuthWithPIN:[NSString stringWithUTF8String:pin] success:^(AFOAuthCredential *credentials) {
        NSLog(@"Access token: %@", credentials.accessToken);
        NSLog(@"Refresh token: %@", credentials.refreshToken);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(NSError *error) {
        STFail(@"%@", error.localizedRecoverySuggestion);
        [self enableAsyncTestingThirdStep:semaphore];
    }];

    [self enableAsyncTestingSecondStep:semaphore];
}

- (void)testAccountLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    [JPImgurAccount accountWithClient:client username:@"me" success:^(JPImgurAccount *account) {
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(NSError *error) {
        STFail(@"%@", error.localizedRecoverySuggestion);
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

@end
