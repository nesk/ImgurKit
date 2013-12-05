//
//  ImgurPartialAlbum.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import "IKBasicAlbum.h"

#import "NSError+ImgurKit.h"
#import "IKClient.h"
#import "IKBasicImage.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IKBasicAlbum;

#pragma mark - Create

+ (RACSignal *)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs success:(void (^)(IKBasicAlbum *))success failure:(void (^)(NSError *))failure
{
    return [self createAlbumWithTitle:title description:description imageIDs:imageIDs privacy:IKDefaultPrivacy layout:IKDefaultLayout cover:nil success:success failure:failure];
}

+ (RACSignal *)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs privacy:(IKPrivacy)privacy layout:(IKLayout)layout cover:(IKBasicImage *)cover success:(void (^)(IKBasicAlbum *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    // Adding used parameters:
    
    if(title != nil)
        [parameters setObject:title forKey:@"title"];
    if(description != nil)
        [parameters setObject:description forKey:@"description"];
    if(cover != nil)
        [parameters setObject:cover.imageID forKey:@"cover"];
    
    if(imageIDs != nil)
    {
        NSString *idsParameter = @"";
        for (IKBasicImage *imageID in imageIDs) {
            if([imageID isKindOfClass:[NSString class]])
                idsParameter = [NSString stringWithFormat:@"%@%@,", idsParameter, imageID];
            else
                @throw [NSException exceptionWithName:@"ImgurObjectTypeException"
                                               reason:@"Objects contained in this array should be of type NSString"
                                             userInfo:[NSDictionary dictionaryWithObject:imageIDs forKey:@"images"]];
        }
        
        // Removing the last comma, which is useless
        [parameters setObject:[idsParameter substringToIndex:[idsParameter length] - 1] forKey:@"ids"];
    }
    
    if(privacy != IKDefaultPrivacy)
    {
        NSString *parameterValue;
        
        switch (privacy) {
            case IKPublicPrivacy:
                parameterValue = @"public";
                break;
                
            case IKHiddenPrivacy:
                parameterValue = @"hidden";
                break;
                
            case IKSecretPrivacy:
                parameterValue = @"secret";
                break;
                
            default:
                break;
        }
        
        if(parameterValue)
            [parameters setObject:parameterValue forKey:@"privacy"];
    }
    
    if (layout != IKDefaultLayout)
    {
        NSString *parameterValue;
        
        switch (layout) {
            case IKBlogLayout:
                parameterValue = @"blog";
                break;
                
            case IKGridLayout:
                parameterValue = @"grid";
                break;
                
            case IKHorizontalLayout:
                parameterValue = @"horizontal";
                break;
                
            case IKVerticalLayout:
                parameterValue = @"vertical";
                break;
                
            default:
                break;
        }
        
        if(parameterValue)
            [parameters setObject:parameterValue forKey:@"layout"];
    }

    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] postPath:@"album" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *JSONError = nil;
            IKBasicAlbum *album = [[self alloc] initWithJSONObject:responseObject error:&JSONError];

            if(!JSONError) {
                [subscriber sendNext:album];
                [subscriber sendCompleted];
                if(success)
                    success(album);
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

#pragma mark - Load

- (instancetype)initWithJSONObject:(NSData *)object error:(NSError *__autoreleasing *)error
{
    self = [super init];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:error];

    if(!*error) {
        data = [data objectForKey:@"data"];
        
        _albumID = [data objectForKey:@"id"];
        _deletehash = [data objectForKey:@"deletehash"];
    }
    else {
        self = nil;
    }
    
    return self;
}

#pragma mark - Delete

+ (RACSignal *)deleteAlbumWithID:(NSString *)albumID success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"album/%@", albumID];

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
    return [NSString stringWithFormat:@"albumID: %@; deletehash: %@", _albumID, _deletehash];
}

@end
