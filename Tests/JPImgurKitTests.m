//
//  JPImgurKitFrameworkTests.m
//  JPImgurKitFrameworkTests
//
//  Created by Johann Pardanaud on 27/06/13.
//  Distributed under the MIT license.
//

#import "JPImgurKitTests.h"

#import "SenTestingKitAsync.h"
#import "JPImgurKit.h"

@implementation JPImgurKitTests;

#pragma mark - Setup

- (void)setUp
{
    [super setUp];
    
    NSDictionary *infos = [[NSBundle bundleForClass:[self class]] infoDictionary];
    imgurVariousValues = [infos objectForKey:@"imgurVariousValues"];
    
    NSDictionary *imgurClient = [infos objectForKey:@"imgurClient"];
    NSString *clientID = [imgurClient objectForKey:@"id"];
    NSString *clientSecret = [imgurClient objectForKey:@"secret"];

    NSString *accessToken = [[infos objectForKey:@"imgurUser"] objectForKey:@"accessToken"];
    
    [[JPImgurClient sharedInstanceWithClientID:clientID secret:clientSecret] setAuthorizationHeaderWithToken:accessToken];
}

#pragma mark - Authenticate

- (void)testAuthorizationURLWithPINAsync
{
    NSURL *url = [[JPImgurClient sharedInstance] getAuthorizationURLUsingPIN];
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        STSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
    }];
    
    [request start];
}

- (void)testAuthenticateUsingOAuthWithPINAsync
{
    JPImgurClient *client = [JPImgurClient sharedInstance];
    
    [[NSWorkspace sharedWorkspace] openURL:[client getAuthorizationURLUsingPIN]];
    
    NSLog(@"Enter the code PIN");
    char pin[20];
    scanf("%s", pin);

    [client authenticateUsingOAuthWithPIN:[NSString stringWithUTF8String:pin] success:^(AFOAuthCredential *credentials) {
        NSLog(@"Access token: %@", credentials.accessToken);
        NSLog(@"Refresh token: %@", credentials.refreshToken);
        STSuccess();
    } failure:^(NSError *error) {
        STFail(@"%@", error.localizedRecoverySuggestion);
    }];
}

#pragma mark - Test Account endpoints

- (void)testAccountLoadingAsync
{
    [JPImgurAccount accountWithUsername:@"me" success:^(JPImgurAccount *account) {
        NSLog(@"%@", account);
        STSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
    }];
}

#pragma mark - Test Image endpoints

- (void)testImageLoadingAsync
{
    NSString *imageID = [imgurVariousValues objectForKey:@"imageID"];
    
    [JPImgurImage imageWithID:imageID success:^(JPImgurImage *image) {
        NSLog(@"%@", image);
        STSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
    }];
}

- (void)testGalleryImageLoadingAsync
{
    NSString *imageID = [imgurVariousValues objectForKey:@"imageID"];
    
    [JPImgurGalleryImage imageWithID:imageID success:^(JPImgurGalleryImage *image) {
        NSLog(@"%@", image);
        STSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
    }];
}

- (void)testImageUploadingWithFileAsync
{
    NSURL *imageURL = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"image-example" ofType:@"png"]];

    [JPImgurImage uploadImageWithFileURL:imageURL success:^(JPImgurBasicImage *image) {
        NSLog(@"%@", image);
        STSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
    }];
}

- (void)testImageUploadingWithURLAsync
{
    NSURL *imageURL = [NSURL URLWithString:[imgurVariousValues objectForKey:@"imageURL"]];
    
    [JPImgurImage uploadImageWithURL:imageURL success:^(JPImgurBasicImage *image) {
        NSLog(@"%@", image);
        STSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
    }];
}

#pragma mark - Test Album endpoints

- (void)testAlbumCreationAsync
{
    [JPImgurAlbum createAlbumWithTitle:@"testAlbumCreation" description:nil imageIDs:nil success:^(JPImgurBasicAlbum *album) {
        NSLog(@"%@", album);
        STSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
    }];
}

- (void)testAlbumLoadingAsync
{
    NSString *albumID = [imgurVariousValues objectForKey:@"albumID"];
    
    [JPImgurAlbum albumWithID:albumID success:^(JPImgurAlbum *album) {
        NSLog(@"%@", album);
        STSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
    }];
}

- (void)testGalleryAlbumLoadingAsync
{
    NSString *albumID = [imgurVariousValues objectForKey:@"albumID"];
    
    [JPImgurGalleryAlbum albumWithID:albumID success:^(JPImgurGalleryAlbum *album) {
        NSLog(@"%@", album);
        STSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
    }];
}

@end
