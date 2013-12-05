//
//  ImgurKitFrameworkTests.m
//  ImgurKitFrameworkTests
//
//  Created by Johann Pardanaud on 27/06/13.
//  Distributed under the MIT license.
//

#import "ImgurKitTests.h"

#import "SenTestingKitAsync.h"
#import "ImgurKit.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ImgurKitTests;

#pragma mark - Setup

- (void)setUp
{
    [super setUp];
    
    // Storing various testing values
    
    NSDictionary *infos = [[NSBundle bundleForClass:[self class]] infoDictionary];
    imgurVariousValues = [infos objectForKey:@"imgurVariousValues"];
    
    // Initializing the client
    
    NSDictionary *imgurClient = [infos objectForKey:@"imgurClient"];
    NSString *clientID = [imgurClient objectForKey:@"id"];
    NSString *clientSecret = [imgurClient objectForKey:@"secret"];

    NSString *accessToken = [[infos objectForKey:@"imgurUser"] objectForKey:@"accessToken"];
    
    [[IKClient sharedInstanceWithClientID:clientID secret:clientSecret] setAuthorizationHeaderWithToken:accessToken];
}

#pragma mark - Test utilities methods

- (void)testTokenComponents
{
    // A typical URL used by Imgur for returning access tokens
    NSURL *tokenURL = [NSURL URLWithString:[imgurVariousValues objectForKey:@"tokenURL"]];

    NSDictionary *tokenComponents = [tokenURL tokenComponents];

    if([tokenComponents count] != 5) {
        STFail(@"Unexpected number of token components. Expecting 5, got %lu.", (unsigned long)[tokenComponents count]);
    }

    NSLog(@"%@", tokenComponents);
}

- (void)testCodeComponent
{
    // A typical URL used by Imgur for returning a pin code
    NSURL *codeURL = [NSURL URLWithString:[imgurVariousValues objectForKey:@"codeURL"]];

    NSString *codeComponent = [codeURL codeComponent];

    if(![codeComponent isEqual: @"AUTHORIZATION_CODE"]) {
        STFail(@"Unexpected code component. Expecting \"AUTHORIZATION_CODE\", got \"%@\".", codeComponent);
    }
}

#pragma mark - Test authentication

- (void)testAuthorizationURLAsync
{
    NSURL *url = [[IKClient sharedInstance] authorizationURLUsing:IKPINAuthType];
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        STSuccess();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@` with method %@", (long)[response statusCode], [[response URL] absoluteString], [operation.request HTTPMethod]);
    }];
    
    [request start];
}

- (void)testAuthenticateUsingOAuthWithPINAsync
{
    IKClient *client = [IKClient sharedInstance];
    
    [[NSWorkspace sharedWorkspace] openURL:[client authorizationURLUsing:IKPINAuthType]];
    
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
    [IKAccount accountWithUsername:@"me" success:^(IKAccount *account) {
        NSLog(@"%@", account);
        STSuccess();
    } failure:^(NSError *error) {
        AFHTTPRequestOperation *operation = [[error userInfo] objectForKey:IKHTTPRequestOperationKey];
        NSHTTPURLResponse *response = operation.response;
        STFail(@"Unexpected status code (%ld) returned from URL `%@` with method %@", (long)[response statusCode], [[response URL] absoluteString], [operation.request HTTPMethod]);
    }];
}

#pragma mark - Test Image endpoints

- (void)testImageWorkflowAsync
{
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"image-example" ofType:@"jpg"]];

    [[[[[
     [IKImage uploadImageWithFileURL:fileURL success:nil failure:nil]

     flattenMap:^RACStream *(IKBasicImage *image) {
         NSLog(@"%@", image);
         return [IKGalleryImage submitImageWithID:image.imageID title:[imgurVariousValues objectForKey:@"title"] success:nil failure:nil];
     }]
     flattenMap:^RACStream *(NSString *imageID) {
         return [IKGalleryImage imageWithID:imageID success:nil failure:nil];
     }]
     flattenMap:^RACStream *(IKGalleryImage *image) {
         NSLog(@"%@", image);
         return [IKGalleryImage removeImageWithID:image.imageID success:nil failure:nil];
     }]
     flattenMap:^RACStream *(NSString *imageID) {
         return [IKImage deleteImageWithID:imageID success:nil failure:nil];
     }]

     subscribeNext:^(id x) {
         STSuccess();
     } error:^(NSError *error) {
         AFHTTPRequestOperation *operation = [[error userInfo] objectForKey:IKHTTPRequestOperationKey];
         NSHTTPURLResponse *response = operation.response;
         STFail(@"Unexpected status code (%ld) returned from URL `%@` with method %@", (long)[response statusCode], [[response URL] absoluteString], [operation.request HTTPMethod]);
     }];
}

#pragma mark - Test Album endpoints

- (void)testAlbumWorkflowAsync
{
    NSString *imageID = [imgurVariousValues objectForKey:@"imageID"];

    [[[[[
     [IKAlbum createAlbumWithTitle:nil description:nil imageIDs:@[imageID] success:nil failure:nil]

     flattenMap:^RACStream *(IKBasicAlbum *album) {
         NSLog(@"%@", album);
         return [IKGalleryAlbum submitAlbumWithID:album.albumID title:[imgurVariousValues objectForKey:@"title"] success:nil failure:nil];
     }]
     flattenMap:^RACStream *(NSString *albumID) {
         return [IKGalleryAlbum albumWithID:albumID success:nil failure:nil];
     }]
     flattenMap:^RACStream *(IKGalleryAlbum *album) {
         NSLog(@"%@", album);
         return [IKGalleryAlbum removeAlbumWithID:album.albumID success:nil failure:nil];
     }]
     flattenMap:^RACStream *(NSString *albumID) {
         return [IKAlbum deleteAlbumWithID:albumID success:nil failure:nil];
     }]

     subscribeNext:^(id x) {
         STSuccess();
     } error:^(NSError *error) {
         AFHTTPRequestOperation *operation = [[error userInfo] objectForKey:IKHTTPRequestOperationKey];
         NSHTTPURLResponse *response = operation.response;
         STFail(@"Unexpected status code (%ld) returned from URL `%@` with method %@", (long)[response statusCode], [[response URL] absoluteString], [operation.request HTTPMethod]);
     }];
}

@end
