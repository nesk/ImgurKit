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

+ (void)accountWithClient:(JPImgurClient *)client username:(NSString *)username success:(void (^)(JPImgurAccount *))success failure:(void (^)(NSError *))failure
{
    JPImgurAccount *account = [JPImgurAccount new];
    account.client = client;
    [account loadAccountWithUsername:username success:success failure:failure];
}

- (void)loadAccountWithUsername:(NSString *)username success:(void (^)(JPImgurAccount *))success failure:(void (^)(NSError *))failure
{
    [self checkForUndefinedClient];
    
    NSString *path = [NSString stringWithFormat:@"account/%@", username];
    
    [self.client getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setAccountPropertiesWithJSONObject:responseObject];
        success(self);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)setAccountPropertiesWithJSONObject:(NSData *)object
{
    NSDictionary *data = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = (NSDictionary *)[data objectForKey:@"data"];

    _accountID = [[data objectForKey:@"id"] integerValue];
    _url = (NSString *)[data objectForKey:@"url"];
    _bio = (NSString *)[data objectForKey:@"bio"];
    _reputation = [[data objectForKey:@"reputation"] floatValue];
    _created = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"created"] integerValue]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"accountID: %lu; url: \"%@\"; bio: \"%@\"; reputation: %.2f; created: %@",
            (unsigned long)_accountID, _url, _bio, _reputation, _created];
}

@end
