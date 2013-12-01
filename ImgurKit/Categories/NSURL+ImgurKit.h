//
//  NSString+JPImgurKit.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 13/10/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

@interface NSURL (JPImgurKit)

- (NSDictionary *)tokenComponents;
- (NSString *)codeComponent;

@end
