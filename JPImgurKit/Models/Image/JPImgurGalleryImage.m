//
//  JPImgurGalleryImage.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurGalleryImage.h"
#import "JPImgurClient.h"

@implementation JPImgurGalleryImage

+ (void)imageWithID:(NSString *)imageID success:(void (^)(JPImgurGalleryImage *image))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"gallery/image/%@", imageID];
    
    [[JPImgurClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[self alloc] initWithJSONObject:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (instancetype)initWithJSONObject:(NSData *)object
{
    self = [super initWithJSONObject:object];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];
    
    _accountURL = [data objectForKey:@"account_url"];
    _ups = [[data objectForKey:@"ups"] integerValue];
    _downs = [[data objectForKey:@"downs"] integerValue];
    _score = [[data objectForKey:@"score"] integerValue];

    NSString *vote = [data objectForKey:@"vote"];
    if([vote isEqualToString: @"up"])
        _vote = 1;
    else if ([vote isEqualToString:@"down"])
        _vote = -1;
    else
        _vote = 0;
    
    return self;
}

#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@; accountURL: \"%@\"; ups: %ld; downs: %ld; score: %ld; vote: %ld",
            [super description], _accountURL, (long)_ups, (long)_downs, (long)_score, (long)_vote];
}

@end
