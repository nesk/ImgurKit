//
//  IKGalleryAlbum.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "IKGalleryAlbum.h"

#import "NSError+ImgurKit.h"
#import "IKClient.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IKGalleryAlbum;

#pragma mark - Submit

+ (RACSignal *)submitAlbumWithID:(NSString *)albumID title:(NSString *)title success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    return [self submitAlbumWithID:albumID title:title terms:YES success:success failure:failure];
}

+ (RACSignal *)submitAlbumWithID:(NSString *)albumID title:(NSString *)title terms:(BOOL)terms success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:title, [NSNumber numberWithBool:terms], nil]
                                                           forKeys:[NSArray arrayWithObjects:@"title", @"terms", nil]];
    
    NSString *path = [NSString stringWithFormat:@"gallery/album/%@", albumID];

    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:albumID];
            [subscriber sendCompleted];
            if(success)
                success(albumID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSError *finalError = [NSError errorWithError:error additionalUserInfo:@{ IKHTTPRequestOperationKey: operation }];

            [subscriber sendError:finalError];
            if(failure)
                failure(finalError);
        }];

        return nil;
    }] replayLast];
}

#pragma mark - Load

+ (RACSignal *)albumWithID:(NSString *)albumID success:(void (^)(IKGalleryAlbum *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"gallery/album/%@", albumID];


    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            IKGalleryAlbum *album = [[self alloc] initWithJSONObject:responseObject];

            [subscriber sendNext:album];
            [subscriber sendCompleted];
            if(success)
                success(album);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSError *finalError = [NSError errorWithError:error additionalUserInfo:@{ IKHTTPRequestOperationKey: operation }];

            [subscriber sendError:finalError];
            if(failure)
                failure(finalError);
        }];

        return nil;
    }] replayLast];
}

- (instancetype)initWithJSONObject:(NSData *)object
{
    self = [super initWithJSONObject:object];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];
    
    _ups = [[data objectForKey:@"ups"] integerValue];
    _downs = [[data objectForKey:@"downs"] integerValue];
    _score = [[data objectForKey:@"score"] integerValue];
    
    NSString *vote = [data objectForKey:@"vote"];
    if([vote isEqualToString: @"up"])
        _vote = 1;
    else if ([vote isEqualToString:@"down"])
        _vote = -1;
    else
        _vote = 0;
    
    return self;
}

#pragma mark - Remove

+ (RACSignal *)removeAlbumWithID:(NSString *)albumID success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"gallery/%@", albumID];

    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:albumID];
            [subscriber sendCompleted];
            if(success)
                success(albumID);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSError *finalError = [NSError errorWithError:error additionalUserInfo:@{ IKHTTPRequestOperationKey: operation }];

            [subscriber sendError:finalError];
            if(failure)
                failure(finalError);
        }];

        return nil;
    }] replayLast];
}

#pragma mark - Describe

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@; ups: %ld; downs: %ld; score: %ld; vote: %ld",
            [super description], (long)_ups, (long)_downs, (long)_score, (long)_vote];
}

@end
