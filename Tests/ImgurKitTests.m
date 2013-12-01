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
    
    [[ImgurClient sharedInstanceWithClientID:clientID secret:clientSecret] setAuthorizationHeaderWithToken:accessToken];
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
    NSURL *url = [[ImgurClient sharedInstance] authorizationURLUsing:ImgurAuthTypePIN];
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
    ImgurClient *client = [ImgurClient sharedInstance];
    
    [[NSWorkspace sharedWorkspace] openURL:[client authorizationURLUsing:ImgurAuthTypePIN]];
    
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
    [ImgurAccount accountWithUsername:@"me" success:^(ImgurAccount *account) {
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
        [ImgurImage uploadImageWithFileURL:fileURL success:^(ImgurBasicImage *image) {
            NSLog(@"%@", image);
            submit(image.imageID);
        } failure:^(NSError *error) {
            AFHTTPRequestOperation *operation = [[error userInfo] objectForKey:ImgurHTTPRequestOperationKey];
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    submit = ^(NSString *imageID) {
        [ImgurGalleryImage submitImageWithID:imageID title:[imgurVariousValues objectForKey:@"title"] success:^{
            load(imageID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    load = ^(NSString *imageID) {
        [ImgurGalleryImage imageWithID:imageID success:^(ImgurGalleryImage *image) {
            NSLog(@"%@", image);
            remove(imageID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    remove = ^(NSString *imageID) {
        [ImgurGalleryImage removeImageWithID:imageID success:^{
            delete(imageID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    delete = ^(NSString *imageID) {
        [ImgurImage deleteImageWithID:imageID success:^{
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
        [ImgurAlbum createAlbumWithTitle:nil description:nil imageIDs:[NSArray arrayWithObjects:imageID, nil] success:^(ImgurBasicAlbum *album) {
            NSLog(@"%@", album);
            submit(album.albumID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    submit = ^(NSString *albumID) {
        [ImgurGalleryAlbum submitAlbumWithID:albumID title:[imgurVariousValues objectForKey:@"title"] success:^{
            load(albumID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    load = ^(NSString *albumID) {
        [ImgurGalleryAlbum albumWithID:albumID success:^(ImgurAlbum *album) {
            NSLog(@"%@", album);
            remove(albumID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    remove = ^(NSString *albumID) {
        [ImgurGalleryAlbum removeAlbumWithID:albumID success:^{
            delete(albumID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSHTTPURLResponse *response = operation.response;
            STFail(@"Unexpected status code (%ld) returned from URL `%@`", (long)[response statusCode], [[response URL] absoluteString]);
        }];
    };
    
    delete = ^(NSString *albumID) {
        [ImgurAlbum deleteAlbumWithID:albumID success:^{
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