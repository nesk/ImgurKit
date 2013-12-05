//
//  IKGalleryImage.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "IKGalleryImage.h"

#import "NSError+ImgurKit.h"
#import "IKClient.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IKGalleryImage;

#pragma mark - Submit

+ (RACSignal *)submitImageWithID:(NSString *)imageID title:(NSString *)title success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    return [self submitImageWithID:imageID title:title terms:YES success:success failure:failure];
}

+ (RACSignal *)submitImageWithID:(NSString *)imageID title:(NSString *)title terms:(BOOL)terms success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:title, [NSNumber numberWithBool:terms], nil]
                                                           forKeys:[NSArray arrayWithObjects:@"title", @"terms", nil]];
    
    NSString *path = [NSString stringWithFormat:@"gallery/image/%@", imageID];

    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:imageID];
            [subscriber sendCompleted];
            if(success)
                success(imageID);
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

+(RACSignal *)imageWithID:(NSString *)imageID success:(void (^)(IKGalleryImage *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"gallery/image/%@", imageID];
    
    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *JSONError = nil;
            IKGalleryImage *image = [[self alloc] initWithJSONObject:responseObject error:&JSONError];

            if(!JSONError) {
                [subscriber sendNext:image];
                [subscriber sendCompleted];
                if(success)
                    success(image);
            }
            else {
                NSError *finalError = [NSError errorWithError:JSONError additionalUserInfo:@{ IKJSONDataKey: responseObject }];

                [subscriber sendError:finalError];
                if(failure)
                    failure(finalError);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSError *finalError = [NSError errorWithError:error additionalUserInfo:@{ IKHTTPRequestOperationKey: operation }];

            [subscriber sendError:finalError];
            if(failure)
                failure(finalError);
        }];

        return nil;
    }] replayLast];
}

- (instancetype)initWithJSONObject:(NSData *)object error:(NSError *__autoreleasing *)error
{
    self = [super initWithJSONObject:object error:error];

    if(!*error) {
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
        data = [data objectForKey:@"data"];
        
        _accountURL = [data objectForKey:@"account_url"];
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
    }
    else {
        self = nil;
    }

    return self;
}

#pragma mark - Remove

+ (RACSignal *)removeImageWithID:(NSString *)imageID success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"gallery/%@", imageID];

    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:imageID];
            [subscriber sendCompleted];
            if(success)
                success(imageID);
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
            @"%@; accountURL: \"%@\"; ups: %ld; downs: %ld; score: %ld; vote: %ld",
            [super description], _accountURL, (long)_ups, (long)_downs, (long)_score, (long)_vote];
}

@end
