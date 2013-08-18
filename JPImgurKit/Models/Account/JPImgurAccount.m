//
//  JPImgurAccount.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 10/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurAccount.h"
#import "JPImgurClient.h"

@implementation JPImgurAccount

+ (void)accountWithUsername:(NSString *)username success:(void (^)(JPImgurAccount *account))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"account/%@", username];
    
    [[JPImgurClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[self alloc] initWithJSONObject:responseObject]);
    } failure:failure];
}

+ (instancetype)accountWithID:(NSUInteger)accountID
{
    return [[self alloc] initWithID:accountID];
}

- (instancetype)initWithID:(NSUInteger)accountID
{
    self = [super init];
    
    _accountID = accountID;
    
    return self;
}

- (instancetype)initWithJSONObject:(NSData *)object
{
    self = [super init];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];

    _accountID = [[data objectForKey:@"id"] integerValue];
    _url = [data objectForKey:@"url"];
    _bio = [data objectForKey:@"bio"];
    _reputation = [[data objectForKey:@"reputation"] floatValue];
    _created = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"created"] integerValue]];
    
    return self;
}

#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"accountID: %lu; url: \"%@\"; bio: \"%@\"; reputation: %.2f; created: %@",
            (unsigned long)_accountID, _url, _bio, _reputation, _created];
}

@end
