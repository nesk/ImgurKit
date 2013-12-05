//
//  IKAccount.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 10/07/13.
//  Distributed under the MIT license.
//

#import "IKAccount.h"

#import "NSError+ImgurKit.h"
#import "IKClient.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IKAccount;

#pragma mark - Load

+ (RACSignal *)accountWithUsername:(NSString *)username success:(void (^)(IKAccount *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"account/%@", username];

    // Return a signal that creates and runs the operation

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [[IKClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *JSONError = nil;
            IKAccount *account = [[self alloc] initWithJSONObject:responseObject error:&JSONError];

            if(!JSONError) {
                [subscriber sendNext:account];
                [subscriber sendCompleted];
                if(success)
                    success(account);
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

- (instancetype)initWithJSONObject:(NSData *)object error:(NSError * __autoreleasing *)error
{
    self = [super init];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:error];

    if(!*error) {
        data = [data objectForKey:@"data"];

        _accountID = [[data objectForKey:@"id"] integerValue];
        _url = [data objectForKey:@"url"];
        _bio = [data objectForKey:@"bio"];
        _reputation = [[data objectForKey:@"reputation"] floatValue];
        _created = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"created"] integerValue]];
    }
    else {
        self = nil;
    }
    
    return self;
}

#pragma mark - Describe

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"accountID: %lu; url: \"%@\"; bio: \"%@\"; reputation: %.2f; created: %@",
            (unsigned long)_accountID, _url, _bio, _reputation, _created];
}

@end
