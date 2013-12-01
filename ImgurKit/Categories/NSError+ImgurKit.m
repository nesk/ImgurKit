//
//  NSError+JPImgurKit.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 23/11/13.
//  Distributed under the MIT license.
//

#import "NSError+JPImgurKit.h"

NSString * const JPImgurHTTPRequestOperationKey = @"JPImgurHTTPRequestOperation";

@implementation NSError (JPImgurKit)

+ (NSError *)errorWithError:(NSError *)error additionalUserInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *finalUserInfo = [NSMutableDictionary new];

    [finalUserInfo addEntriesFromDictionary:[error userInfo]];
    [finalUserInfo addEntriesFromDictionary:userInfo];

    return [NSError errorWithDomain:[error domain] code:[error code] userInfo:finalUserInfo];
}

@end
