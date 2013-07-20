//
//  JPImgurBasicModel.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 14/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurBasicModel.h"

@implementation JPImgurBasicModel

- (void)checkForUndefinedClient
{
    if(![self client])
        @throw [NSException exceptionWithName:@"ClientUndefined" reason:@"You must specify a client before using requests" userInfo:nil];
}

@end
