//
//  ImgurPartialAlbum.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import "ImgurBasicAlbum.h"
#import "ImgurClient.h"
#import "ImgurBasicImage.h"

@implementation ImgurBasicAlbum;

#pragma mark - Create

+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs success:(void (^)(ImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self createAlbumWithTitle:title description:description imageIDs:imageIDs privacy:ImgurDefaultPrivacy layout:ImgurDefaultLayout cover:nil success:success failure:failure];
}

+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs privacy:(ImgurPrivacy)privacy layout:(ImgurLayout)layout cover:(ImgurBasicImage *)cover success:(void (^)(ImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    // Adding used parameters:
    
    if(title != nil)
        [parameters setObject:title forKey:@"title"];
    if(description != nil)
        [parameters setObject:description forKey:@"description"];
    if(cover != nil)
        [parameters setObject:cover.imageID forKey:@"cover"];
    
    if(imageIDs != nil)
    {
        NSString *idsParameter = @"";
        for (ImgurBasicImage *imageID in imageIDs) {
            if([imageID isKindOfClass:[NSString class]])
                idsParameter = [NSString stringWithFormat:@"%@%@,", idsParameter, imageID];
            else
                @throw [NSException exceptionWithName:@"ImgurObjectTypeException"
                                               reason:@"Objects contained in this array should be of type NSString"
                                             userInfo:[NSDictionary dictionaryWithObject:imageIDs forKey:@"images"]];
        }
        
        // Removing the last comma, which is useless
        [parameters setObject:[idsParameter substringToIndex:[idsParameter length] - 1] forKey:@"ids"];
    }
    
    if(privacy != ImgurDefaultPrivacy)
    {
        NSString *parameterValue;
        
        switch (privacy) {
            case ImgurPublicPrivacy:
                parameterValue = @"public";
                break;
                
            case ImgurHiddenPrivacy:
                parameterValue = @"hidden";
                break;
                
            case ImgurSecretPrivacy:
                parameterValue = @"secret";
                break;
                
            default:
                break;
        }
        
        if(parameterValue)
            [parameters setObject:parameterValue forKey:@"privacy"];
    }
    
    if (layout != ImgurDefaultLayout)
    {
        NSString *parameterValue;
        
        switch (layout) {
            case ImgurBlogLayout:
                parameterValue = @"blog";
                break;
                
            case ImgurGridLayout:
                parameterValue = @"grid";
                break;
                
            case ImgurHorizontalLayout:
                parameterValue = @"horizontal";
                break;
                
            case ImgurVerticalLayout:
                parameterValue = @"vertical";
                break;
                
            default:
                break;
        }
        
        if(parameterValue)
            [parameters setObject:parameterValue forKey:@"layout"];
    }
    
    // Creating the request:
    
    [[ImgurClient sharedInstance] postPath:@"album" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[ImgurBasicAlbum alloc] initWithJSONObject:responseObject]);
    } failure:failure];
}

#pragma mark - Load

- (instancetype)initWithJSONObject:(NSData *)object
{
    self = [super init];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];
    
    _albumID = [data objectForKey:@"id"];
    _deletehash = [data objectForKey:@"deletehash"];
    
    return self;
}

#pragma mark - Delete

+ (void)deleteAlbumWithID:(NSString *)albumID success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"album/%@", albumID];
    
    [[ImgurClient sharedInstance] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:failure];
}

#pragma mark - Describe

- (NSString *)description
{
    return [NSString stringWithFormat:@"albumID: %@; deletehash: %@", _albumID, _deletehash];
}

@end
