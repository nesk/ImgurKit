//
//  JPImgurPartialAlbum.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 24/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurBasicAlbum.h"
#import "JPImgurClient.h"
#import "JPImgurBasicImage.h"

@implementation JPImgurBasicAlbum

#pragma mark - Creating an album

+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description images:(NSArray *)images success:(void (^)(JPImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self createAlbumWithTitle:title description:description images:images privacy:JPImgurDefaultPrivacy layout:JPImgurDefaultLayout cover:nil success:success failure:failure];
}

+ (void)createAlbumWithTitle:(NSString *)title description:(NSString *)description images:(NSArray *)images privacy:(JPImgurPrivacy)privacy layout:(JPImgurLayout)layout cover:(JPImgurBasicImage *)cover success:(void (^)(JPImgurBasicAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    // Adding used parameters:
    
    if(title != nil)
        [parameters setObject:title forKey:@"title"];
    if(description != nil)
        [parameters setObject:description forKey:@"description"];
    if(cover != nil)
        [parameters setObject:cover.imageID forKey:@"cover"];
    
    if(images != nil)
    {
        NSString *idsParameter = @"";
        for (JPImgurBasicImage *image in images) {
            if([image isKindOfClass:[JPImgurBasicImage class]])
                idsParameter = [NSString stringWithFormat:@"%@%@,", idsParameter, image.imageID];
            else
                @throw [NSException exceptionWithName:@"JPImgurObjectTypeException"
                                               reason:@"Objects contained in this array should be of type JPImgurBasicImage"
                                             userInfo:[NSDictionary dictionaryWithObject:images forKey:@"images"]];
        }
        [parameters setObject:[idsParameter substringToIndex:[idsParameter length] - 1] forKey:@"ids"];
    }
    
    if(privacy != JPImgurDefaultPrivacy)
    {
        NSString *parameterValue;
        
        switch (privacy) {
            case JPImgurPublicPrivacy:
                parameterValue = @"public";
                break;
                
            case JPImgurHiddenPrivacy:
                parameterValue = @"hidden";
                break;
                
            case JPImgurSecretPrivacy:
                parameterValue = @"secret";
                break;
                
            default:
                break;
        }
        
        if(parameterValue)
            [parameters setObject:parameterValue forKey:@"privacy"];
    }
    
    if (layout != JPImgurDefaultLayout)
    {
        NSString *parameterValue;
        
        switch (layout) {
            case JPImgurBlogLayout:
                parameterValue = @"blog";
                break;
                
            case JPImgurGridLayout:
                parameterValue = @"grid";
                break;
                
            case JPImgurHorizontalLayout:
                parameterValue = @"horizontal";
                break;
                
            case JPImgurVerticalLayout:
                parameterValue = @"vertical";
                break;
                
            default:
                break;
        }
        
        if(parameterValue)
            [parameters setObject:parameterValue forKey:@"layout"];
    }
    
    // Creating the request:
    
    [[JPImgurClient sharedInstance] postPath:@"album" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[JPImgurBasicAlbum alloc] initWithJSONObject:responseObject]);
    } failure:failure];
}

#pragma mark - Deleting an album

+ (void)deleteAlbum:(JPImgurBasicAlbum *)album success:(void (^)())success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"album/%@", album.albumID];
    
    [[JPImgurClient sharedInstance] deletePath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:failure];
}

#pragma mark - Setting the album properties

+ (instancetype)albumWithID:(NSString *)albumID
{
    return [[self alloc] initWithID:albumID];
}

- (instancetype)initWithID:(NSString *)albumID
{
    self = [super init];
    
    _albumID = albumID;
    
    return self;
}

- (instancetype)initWithJSONObject:(NSData *)object
{
    self = [super init];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];
    
    _albumID = [data objectForKey:@"id"];
    _deletehash = [data objectForKey:@"deletehash"];
    
    return self;
}

#pragma mark - Visualizing the album properties

- (NSString *)description
{
    return [NSString stringWithFormat:@"albumID: %@; deletehash: %@", _albumID, _deletehash];
}

@end
