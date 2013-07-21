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
    imgurIDExamples = [infos objectForKey:@"imgurIDExamples"];
    
    NSDictionary *imgurClient = [infos objectForKey:@"imgurClient"];
    NSString *clientID = [imgurClient objectForKey:@"id"];
    NSString *clientSecret = [imgurClient objectForKey:@"Secret"];

    NSString *accessToken = [[infos objectForKey:@"imgurUser"] objectForKey:@"accessToken"];
    
    [[JPImgurClient sharedInstanceWithClientID:clientID secret:clientSecret] setAuthorizationHeaderWithToken:accessToken];
}

#pragma mark -

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

#pragma mark -

- (void)testAuthorizationURLWithPIN
{
    NSURL *url = [[JPImgurClient sharedInstance] getAuthorizationURLUsingPIN];
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
    
    JPImgurClient *client = [JPImgurClient sharedInstance];
    
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

#pragma mark -

- (void)testAccountLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    [JPImgurAccount accountWithUsername:@"me" success:^(JPImgurAccount *account) {
        NSLog(@"%@", account);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(NSError *error) {
        STFail(@"%@", error.localizedRecoverySuggestion);
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

#pragma mark -

- (void)testImageLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    NSString *imageID = [imgurIDExamples objectForKey:@"imageID"];
    
    [JPImgurImage imageWithID:imageID success:^(JPImgurImage *image) {
        NSLog(@"%@", image);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(NSError *error) {
        STFail(@"%@", error.localizedRecoverySuggestion);
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

- (void)testGalleryImageLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    NSString *imageID = [imgurIDExamples objectForKey:@"imageID"];
    
    [JPImgurGalleryImage imageWithID:imageID success:^(JPImgurGalleryImage *image) {
        NSLog(@"%@", image);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(NSError *error) {
        STFail(@"%@", error.localizedRecoverySuggestion);
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

#pragma mark -

- (void)testAlbumLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    NSString *albumID = [imgurIDExamples objectForKey:@"albumID"];
    
    [JPImgurAlbum albumWithID:albumID success:^(JPImgurAlbum *album) {
        NSLog(@"%@", album);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(NSError *error) {
        STFail(@"%@", error.localizedRecoverySuggestion);
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

- (void)testGalleryAlbumLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    NSString *albumID = [imgurIDExamples objectForKey:@"albumID"];
    
    [JPImgurGalleryAlbum albumWithID:albumID success:^(JPImgurGalleryAlbum *album) {
        NSLog(@"%@", album);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(NSError *error) {
        STFail(@"%@", error.localizedRecoverySuggestion);
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

@end
