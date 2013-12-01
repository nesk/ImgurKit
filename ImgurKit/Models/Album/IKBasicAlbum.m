//
//  ImgurPartialAlbum.m
//  ImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import "IKBasicAlbum.h"
#import "IKClient.h"
#import "IKBasicImage.h"

@implementation IKBasicAlbum;

#pragma mark - Create

+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs success:(void (^)(IKBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self createAlbumWithTitle:title description:description imageIDs:imageIDs privacy:IKDefaultPrivacy layout:IKDefaultLayout cover:nil success:success failure:failure];
}

+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description imageIDs:(NSArray *)imageIDs privacy:(IKPrivacy)privacy layout:(IKLayout)layout cover:(IKBasicImage *)cover success:(void (^)(IKBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
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
        for (IKBasicImage *imageID in imageIDs) {
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
    
    if(privacy != IKDefaultPrivacy)
    {
        NSString *parameterValue;
        
        switch (privacy) {
            case IKPublicPrivacy:
                parameterValue = @"public";
                break;
                
            case IKHiddenPrivacy:
                parameterValue = @"hidden";
                break;
                
            case IKSecretPrivacy:
                parameterValue = @"secret";
                break;
                
            default:
                break;
        }
        
        if(parameterValue)
            [parameters setObject:parameterValue forKey:@"privacy"];
    }
    
    if (layout != IKDefaultLayout)
    {
        NSString *parameterValue;
        
        switch (layout) {
            case IKBlogLayout:
                parameterValue = @"blog";
                break;
                
            case IKGridLayout:
                parameterValue = @"grid";
                break;
                
            case IKHorizontalLayout:
                parameterValue = @"horizontal";
                break;
                
            case IKVerticalLayout:
                parameterValue = @"vertical";
                break;
                
            default:
                break;
        }
        
        if(parameterValue)
            [parameters setObject:parameterValue forKey:@"layout"];
    }
    
    // Creating the request:
    
    [[IKClient sharedInstance] postPath:@"album" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[IKBasicAlbum alloc] initWithJSONObject:responseObject]);
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
    
    [[IKClient sharedInstance] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:failure];
}

#pragma mark - Describe

- (NSString *)description
{
    return [NSString stringWithFormat:@"albumID: %@; deletehash: %@", _albumID, _deletehash];
}

@end
