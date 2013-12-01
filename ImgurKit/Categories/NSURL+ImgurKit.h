//
//  NSString+ImgurKit.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 13/10/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

@interface NSURL (ImgurKit)

- (NSDictionary *)tokenComponents;
- (NSString *)codeComponent;

@end
