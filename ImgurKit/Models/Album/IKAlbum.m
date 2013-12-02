//
//  IKAlbum.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "IKAlbum.h"

#import "NSError+ImgurKit.h"
#import "IKClient.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IKAlbum;

#pragma mark - Load

+ (RACSignal *)albumWithID:(NSString *)albumID success:(void (^)(IKAlbum *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"album/%@", albumID];

    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            IKAlbum *album = [[self alloc] initWithJSONObject:responseObject];

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

    _title = [data objectForKey:@"title"];
    _description = [data objectForKey:@"description"];
    _datetime = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"datetime"] integerValue]];
    _cover = [data objectForKey:@"cover"];
    _accountURL = [data objectForKey:@"account_url"];
    _privacy = [data objectForKey:@"privacy"];
    _layout = [data objectForKey:@"layout"];
    _views = [[data objectForKey:@"views"] integerValue];
    _link = [data objectForKey:@"link"];
    _imagesCount = [[data objectForKey:@"images_count"] integerValue];
    _images = [data objectForKey:@"images"];
    
    return self;
}

#pragma mark - Describe

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@; title: \"%@\"; description: \"%@\"; datetime: %@; cover: %@; accountURL: \"%@\"; privacy: %@; layout: %@; views: %ld; link: %@; imagesCount: %ld",
            [super description], _title, _description, _datetime, _cover, _accountURL, _privacy, _layout, (long)_views, _link, (long)_imagesCount];
}

@end
