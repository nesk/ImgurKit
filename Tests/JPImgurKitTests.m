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

- (void)enableAsyncTestingFirstStep
{
    semaphore = dispatch_semaphore_create(0);
}

- (void)enableAsyncTestingSecondStep
{
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)enableAsyncTestingThirdStep
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
    [self enableAsyncTestingFirstStep];
    
    JPImgurClient *client = [JPImgurClient sharedInstance];
    
    [[NSWorkspace sharedWorkspace] openURL:[client getAuthorizationURLUsingPIN]];
    
    NSLog(@"Enter the code PIN");
    char pin[20];
    scanf("%s", pin);

    [client authenticateUsingOAuthWithPIN:[NSString stringWithUTF8String:pin] success:^(AFOAuthCredential *credentials) {
        NSLog(@"Access token: %@", credentials.accessToken);
        NSLog(@"Refresh token: %@", credentials.refreshToken);
        [self enableAsyncTestingThirdStep];
    } failure:^(NSError *error) {
        STFail(@"%@", error.localizedRecoverySuggestion);
        [self enableAsyncTestingThirdStep];
    }];

    [self enableAsyncTestingSecondStep];
}

#pragma mark - Account tests

- (void)testAccountLoading
{
    [self enableAsyncTestingFirstStep];
    
    [JPImgurAccount accountWithUsername:@"me" success:^(JPImgurAccount *account) {
        NSLog(@"%@", account);
        [self enableAsyncTestingThirdStep];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep];
    }];
    
    [self enableAsyncTestingSecondStep];
}

#pragma mark - Image tests

- (void)testImageLoading
{
    [self enableAsyncTestingFirstStep];
    
    NSString *imageID = [imgurVariousValues objectForKey:@"imageID"];
    
    [JPImgurImage imageWithID:imageID success:^(JPImgurImage *image) {
        NSLog(@"%@", image);
        [self enableAsyncTestingThirdStep];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep];
    }];
    
    [self enableAsyncTestingSecondStep];
}

- (void)testGalleryImageLoading
{
    [self enableAsyncTestingFirstStep];
    
    NSString *imageID = [imgurVariousValues objectForKey:@"imageID"];
    
    [JPImgurGalleryImage imageWithID:imageID success:^(JPImgurGalleryImage *image) {
        NSLog(@"%@", image);
        [self enableAsyncTestingThirdStep];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep];
    }];
    
    [self enableAsyncTestingSecondStep];
}

- (void)testImageUploadingWithFile
{
    [self enableAsyncTestingFirstStep];
    
    NSURL *imageURL = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"image-example" ofType:@"png"]];

    [JPImgurImage uploadImageWithFileURL:imageURL success:^(JPImgurBasicImage *image) {
        NSLog(@"%@", image);
        [self enableAsyncTestingThirdStep];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep];
    }];
    
    [self enableAsyncTestingSecondStep];
}

- (void)testImageUploadingWithURL
{
    [self enableAsyncTestingFirstStep];
    
    NSURL *imageURL = [NSURL URLWithString:[imgurVariousValues objectForKey:@"imageURL"]];
    
    [JPImgurImage uploadImageWithURL:imageURL success:^(JPImgurBasicImage *image) {
        NSLog(@"%@", image);
        [self enableAsyncTestingThirdStep];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep];
    }];
    
    [self enableAsyncTestingSecondStep];
}

#pragma mark - Album tests

- (void)testAlbumCreation
{
    [self enableAsyncTestingFirstStep];

    [JPImgurAlbum createAlbumWithTitle:@"testAlbumCreation" description:nil images:nil success:^(JPImgurBasicAlbum *album) {
        NSLog(@"%@", album);
        [self enableAsyncTestingThirdStep];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep];
    }];

    [self enableAsyncTestingSecondStep];
}

- (void)testAlbumLoading
{
    [self enableAsyncTestingFirstStep];
    
    NSString *albumID = [imgurVariousValues objectForKey:@"albumID"];
    
    [JPImgurAlbum albumWithID:albumID success:^(JPImgurAlbum *album) {
        NSLog(@"%@", album);
        [self enableAsyncTestingThirdStep];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep];
    }];
    
    [self enableAsyncTestingSecondStep];
}

- (void)testGalleryAlbumLoading
{
    [self enableAsyncTestingFirstStep];
    
    NSString *albumID = [imgurVariousValues objectForKey:@"albumID"];
    
    [JPImgurGalleryAlbum albumWithID:albumID success:^(JPImgurGalleryAlbum *album) {
        NSLog(@"%@", album);
        [self enableAsyncTestingThirdStep];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        
        [self enableAsyncTestingThirdStep];
    }];
    
    [self enableAsyncTestingSecondStep];
}

@end
