//
//  JPImgurKitFrameworkTests.m
//  JPImgurKitFrameworkTests
//
//  Created by Johann Pardanaud on 27/06/13.
//  Distributed under the MIT license.
//

#import "JPImgurKitTests.h"
#import "JPImgurKit.h"

@implementation JPImgurKitTests

- (void)setUp
{
    [super setUp];
    
    NSDictionary *infos = [[NSBundle bundleForClass:[self class]] infoDictionary];
    imgurVariousValues = [infos objectForKey:@"imgurVariousValues"];
    
    NSDictionary *imgurClient = [infos objectForKey:@"imgurClient"];
    NSString *clientID = [imgurClient objectForKey:@"id"];
    NSString *clientSecret = [imgurClient objectForKey:@"Secret"];

    NSString *accessToken = [[infos objectForKey:@"imgurUser"] objectForKey:@"accessToken"];
    
    [[JPImgurClient sharedInstanceWithClientID:clientID secret:clientSecret] setAuthorizationHeaderWithToken:accessToken];
}

#pragma mark - Enable asynchronous testing

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

#pragma mark - Authentication

- (void)testAuthorizationURLWithPIN
{
    NSURL *url = [[JPImgurClient sharedInstance] getAuthorizationURLUsingPIN];
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    
    [request start];
    [request waitUntilFinished];
    
    NSInteger status = [request.response statusCode];
    
    if(status != 200)
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)status, [url absoluteString]);
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

#pragma mark - Account tests

- (void)testAccountLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    [JPImgurAccount accountWithUsername:@"me" success:^(JPImgurAccount *account) {
        NSLog(@"%@", account);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

#pragma mark - Image tests

- (void)testImageLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    NSString *imageID = [imgurVariousValues objectForKey:@"imageID"];
    
    [JPImgurImage imageWithID:imageID success:^(JPImgurImage *image) {
        NSLog(@"%@", image);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

- (void)testGalleryImageLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    NSString *imageID = [imgurVariousValues objectForKey:@"imageID"];
    
    [JPImgurGalleryImage imageWithID:imageID success:^(JPImgurGalleryImage *image) {
        NSLog(@"%@", image);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

- (void)testImageUploadingWithFile
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    NSURL *imageURL = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"image-example" ofType:@"png"]];

    [JPImgurImage uploadImageWithFileURL:imageURL success:^(JPImgurBasicImage *image) {
        NSLog(@"%@", image);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

- (void)testImageUploadingWithURL
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    NSURL *imageURL = [NSURL URLWithString:[imgurVariousValues objectForKey:@"imageURL"]];
    
    [JPImgurImage uploadImageWithURL:imageURL success:^(JPImgurBasicImage *image) {
        NSLog(@"%@", image);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

#pragma mark - Album tests

- (void)testAlbumCreation
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];

    [JPImgurAlbum createAlbumWithTitle:@"testAlbumCreation" description:nil images:nil success:^(JPImgurBasicAlbum *album) {
        NSLog(@"%@", album);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep:semaphore];
    }];

    [self enableAsyncTestingSecondStep:semaphore];
}

- (void)testAlbumLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    NSString *albumID = [imgurVariousValues objectForKey:@"albumID"];
    
    [JPImgurAlbum albumWithID:albumID success:^(JPImgurAlbum *album) {
        NSLog(@"%@", album);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

- (void)testGalleryAlbumLoading
{
    dispatch_semaphore_t semaphore = [self enableAsyncTestingFirstStep];
    
    NSString *albumID = [imgurVariousValues objectForKey:@"albumID"];
    
    [JPImgurGalleryAlbum albumWithID:albumID success:^(JPImgurGalleryAlbum *album) {
        NSLog(@"%@", album);
        [self enableAsyncTestingThirdStep:semaphore];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep:semaphore];
    }];
    
    [self enableAsyncTestingSecondStep:semaphore];
}

@end
