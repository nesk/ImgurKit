//
//  ImgurGalleryImage.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "ImgurGalleryImage.h"
#import "ImgurClient.h"

@implementation ImgurGalleryImage;

#pragma mark - Submit

+ (void)submitImageWithID:(NSString *)imageID title:(NSString *)title success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self submitImageWithID:imageID title:title terms:YES success:success failure:failure];
}

+ (void)submitImageWithID:(NSString *)imageID title:(NSString *)title terms:(BOOL)terms success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:title, [NSNumber numberWithBool:terms], nil]
                                                           forKeys:[NSArray arrayWithObjects:@"title", @"terms", nil]];
    
    NSString *path = [NSString stringWithFormat:@"gallery/image/%@", imageID];
    
    [[ImgurClient sharedInstance] postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:failure];
}

#pragma mark - Load

+ (void)imageWithID:(NSString *)imageID success:(void (^)(ImgurGalleryImage *image))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"gallery/image/%@", imageID];
    
    [[ImgurClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[self alloc] initWithJSONObject:responseObject]);
    } failure:failure];
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

#pragma mark - Remove

+ (void)removeImageWithID:(NSString *)imageID success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"gallery/%@", imageID];
    
    [[ImgurClient sharedInstance] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:failure];
}

#pragma mark - Describe

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@; accountURL: \"%@\"; ups: %ld; downs: %ld; score: %ld; vote: %ld",
            [super description], _accountURL, (long)_ups, (long)_downs, (long)_score, (long)_vote];
}

@end
