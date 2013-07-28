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

+ (void)imageWithID:(NSString *)imageID success:(void (^)(JPImgurGalleryImage *))success failure:(void (^)(NSError *))failure
{
    [[JPImgurGalleryImage alloc] loadImageWithID:imageID success:success failure:failure];
}

- (void)loadImageWithID:(NSString *)imageID success:(void (^)(JPImgurGalleryImage *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"gallery/image/%@", imageID];
    
    [[JPImgurClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setImagePropertiesWithJSONObject:responseObject];
        success(self);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)setImagePropertiesWithJSONObject:(NSData *)object
{
    [super setImagePropertiesWithJSONObject:object];
    
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
}

#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@; accountURL: \"%@\"; ups: %ld; downs: %ld; score: %ld; vote: %ld",
            [super description], _accountURL, (long)_ups, (long)_downs, (long)_score, (long)_vote];
}

@end
