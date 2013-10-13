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

#import "NSURL+JPImgurKit.h"

@implementation JPImgurKitTests;

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
    
    [[JPImgurClient sharedInstanceWithClientID:clientID secret:clientSecret] setAuthorizationHeaderWithToken:accessToken];
}

#pragma mark - Test utilities methods

- (void)testTokenComponents {
    // A typical URL used by Imgur for returning access tokens
    NSURL *tokenURL = [NSURL URLWithString:[imgurVariousValues objectForKey:@"tokenURL"]];

    NSDictionary *tokenComponents = [tokenURL tokenComponents];

    if([tokenComponents count] != 5) {
        STFail(@"Unexpected number of token components. Expecting 5, got %lu.", (unsigned long)[tokenComponents count]);
    }

    NSLog(@"%@", tokenComponents);
}

#pragma mark - Test authentication

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

- (void)testImageWorkflowAsync
{
    __block WorkBlock upload, submit, load, remove, delete;
    
    upload = ^(NSURL *fileURL) {
        [JPImgurImage uploadImageWithFileURL:fileURL success:^(JPImgurBasicImage *image) {
            NSLog(@"%@", image);
            submit(image.imageID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    submit = ^(NSString *imageID) {
        [JPImgurGalleryImage submitImageWithID:imageID title:[imgurVariousValues objectForKey:@"title"] success:^{
            load(imageID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    load = ^(NSString *imageID) {
        [JPImgurGalleryImage imageWithID:imageID success:^(JPImgurGalleryImage *image) {
            NSLog(@"%@", image);
            remove(imageID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    remove = ^(NSString *imageID) {
        [JPImgurGalleryImage removeImageWithID:imageID success:^{
            delete(imageID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    delete = ^(NSString *imageID) {
        [JPImgurImage deleteImageWithID:imageID success:^{
            STSuccess();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    // Initiates the workflow with the URL of the image
    
    upload([NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"image-example" ofType:@"jpg"]]);
}

#pragma mark - Test Album endpoints

- (void)testAlbumWorkflowAsync
{
    __block WorkBlock create, submit, load, remove, delete;
    
    create = ^(NSString *imageID) {
        [JPImgurAlbum createAlbumWithTitle:nil description:nil imageIDs:[NSArray arrayWithObjects:imageID, nil] success:^(JPImgurBasicAlbum *album) {
            NSLog(@"%@", album);
            submit(album.albumID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    submit = ^(NSString *albumID) {
        [JPImgurGalleryAlbum submitAlbumWithID:albumID title:[imgurVariousValues objectForKey:@"title"] success:^{
            load(albumID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    load = ^(NSString *albumID) {
        [JPImgurGalleryAlbum albumWithID:albumID success:^(JPImgurAlbum *album) {
            NSLog(@"%@", album);
            remove(albumID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    remove = ^(NSString *albumID) {
        [JPImgurGalleryAlbum removeAlbumWithID:albumID success:^{
            delete(albumID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    delete = ^(NSString *albumID) {
        [JPImgurAlbum deleteAlbumWithID:albumID success:^{
            STSuccess();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    // Initiates the workflow with an image ID
    
    create([imgurVariousValues objectForKey:@"imageID"]);
}

@end
