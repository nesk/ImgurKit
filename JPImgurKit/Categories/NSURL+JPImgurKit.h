//
//  NSString+JPImgurKit.h
//  JPImgurKit
//
//  Created by Johann Pardanaud on 13/10/13.
//  Copyright (c) 2013 Johann PARDANAUD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (JPImgurKit)

- (NSDictionary *)tokenComponents;
- (NSString *)codeComponent;

@end
