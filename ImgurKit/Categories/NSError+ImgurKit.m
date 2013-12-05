//
//  NSError+ImgurKit.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 23/11/13.
//  Distributed under the MIT license.
//

#import "NSError+ImgurKit.h"

NSString * const IKHTTPRequestOperationKey = @"IKHTTPRequestOperation";
NSString * const IKJSONDataKey = @"IKJSONData";

@implementation NSError (ImgurKit)

+ (NSError *)errorWithError:(NSError *)error additionalUserInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *finalUserInfo = [NSMutableDictionary new];

    [finalUserInfo addEntriesFromDictionary:[error userInfo]];
    [finalUserInfo addEntriesFromDictionary:userInfo];

    return [NSError errorWithDomain:[error domain] code:[error code] userInfo:finalUserInfo];
}

@end
