//
//  NSError+ImgurKit.h
//  ImgurKit
//
//  Created by Johann Pardanaud on 23/11/13.
//  Distributed under the MIT license.
//

#import <Foundation/Foundation.h>

/**
 Constants used by all the classes to reference some values used inside the `userInfo` dictionary from the `NSError`
 class.
 */

FOUNDATION_EXPORT NSString * const ImgurHTTPRequestOperationKey;

/**
 The `ImgurKit` category for the `NSError` class provides a single method used to copy an error with additional
 informations about the request operation.
 */
@interface NSError (ImgurKit)

/**
 Copy an `NSError` instance with same values and adds the provided user infos to it.
 
 @param error The error to copy.
 @param userInfo The `userInfo` dictionary that will be merged with the informations of the original error. The keys
 provided by this dictionary will override any identical key's value used by the original error.
 */
+ (NSError *)errorWithError:(NSError *)error additionalUserInfo:(NSDictionary *)userInfo;

@end