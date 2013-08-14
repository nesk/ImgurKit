//
//  JPImgurAlbum.m
//  JPImgurKit
//
//  Created by Johann Pardanaud on 11/07/13.
//  Distributed under the MIT license.
//

#import "JPImgurAlbum.h"
#import "JPImgurClient.h"
#import "JPImgurBasicImage.h"

@implementation JPImgurAlbum

#pragma mark - Uploading an image

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

#pragma mark - Loading the album properties

+ (void)albumWithID:(NSString *)albumID success:(void (^)(JPImgurAlbum *album))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"album/%@", albumID];
    
    [[JPImgurClient sharedInstance] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([[self alloc] initWithJSONObject:responseObject]);
    } failure:failure];
}

- (instancetype)initWithJSONObject:(NSData *)object
{
    self = [super initWithJSONObject:object];
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:object options:kNilOptions error:nil];
    data = [data objectForKey:@"data"];

    _title = [data objectForKey:@"title"];
    _description = [data objectForKey:@"description"];
    _datetime = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"datetime"] integerValue]];
    _cover = [data objectForKey:@"cover"];
    _accountURL = [data objectForKey:@"account_url"];
    _privacy = [data objectForKey:@"privacy"];
    _layout = [data objectForKey:@"layout"];
    _views = [[data objectForKey:@"views"] integerValue];
    _link = [data objectForKey:@"link"];
    _imagesCount = [[data objectForKey:@"images_count"] integerValue];
    _images = [data objectForKey:@"images"];
    
    return self;
}

#pragma mark -

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"%@; title: \"%@\"; description: \"%@\"; datetime: %@; cover: %@; accountURL: \"%@\"; privacy: %@; layout: %@; views: %ld; link: %@; imagesCount: %ld",
            [super description], _title, _description, _datetime, _cover, _accountURL, _privacy, _layout, (long)_views, _link, (long)_imagesCount];
}

@end
