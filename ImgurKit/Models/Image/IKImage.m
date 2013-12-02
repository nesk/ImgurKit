//
//  IKImage.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 10/07/13.
//  Distributed under the MIT license.
//

#import "IKImage.h"

#import "NSError+ImgurKit.h"
#import "IKClient.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IKImage;

#pragma mark - Load

+ (RACSignal *)imageWithID:(NSString *)imageID success:(void (^)(IKImage *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"image/%@", imageID];

    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            IKImage *image = [[self alloc] initWithJSONObject:responseObject];

            [subscriber sendNext:image];
            [subscriber sendCompleted];
            if(success)
                success(image);
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
    _type = [data objectForKey:@"type"];
    _animated = [[data objectForKey:@"animated"] boolValue];
    _width = [[data objectForKey:@"width"] integerValue];
    _height = [[data objectForKey:@"height"] integerValue];
    _size = [[data objectForKey:@"size"] integerValue];
    _views = [[data objectForKey:@"views"] integerValue];
    _bandwidth = [[data objectForKey:@"bandwidth"] integerValue];
    
    return self;
}

#pragma mark - Describe

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@; title: \"%@\"; description: \"%@\"; datetime: %@; type: %@; animated: %d; width: %ld; height: %ld; size: %ld; views: %ld; bandwidth: %ld",
            [super description], _title, _description, _datetime, _type, _animated, (long)_width, (long)_height, (long)_size, (long)_views, (long)_bandwidth];
}

@end
