//
//  NSString+ImgurKit.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 13/10/13.
//  Distributed under the MIT license.
//
#import "NSURL+ImgurKit.h"

@implementation NSURL (ImgurKit)

- (NSDictionary *)tokenComponents {
    NSCharacterSet * mySet = [NSCharacterSet characterSetWithCharactersInString:@"#&="];

    NSMutableArray *splittedString = [NSMutableArray arrayWithArray:[[self absoluteString] componentsSeparatedByCharactersInSet:mySet]];
    [splittedString removeObjectAtIndex:0]; // Remove the first part of the URL, which is before the `#` character

    NSMutableDictionary *pathComponents = [NSMutableDictionary new];

    for(NSUInteger i = 0 ; i < [splittedString count] ; i+=2) {
        [pathComponents setObject:splittedString[i+1] forKey:splittedString[i]];
    }

    return [NSDictionary dictionaryWithDictionary:pathComponents];
}

- (NSString *)codeComponent {
    return [[self absoluteString] componentsSeparatedByString:@"="][1];
}

@end
