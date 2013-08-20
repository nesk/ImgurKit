//
//  JPImgurKitFrameworkTests.h
//  JPImgurKitFrameworkTests
//
//  Created by Johann Pardanaud on 27/06/13.
//  Distributed under the MIT license.
//

#import <SenTestingKit/SenTestingKit.h>

@class JPImgurClient;

@interface JPImgurKitTests : SenTestCase
{
    NSDictionary *imgurVariousValues;
    dispatch_semaphore_t semaphore;
}

#pragma mark - Enable asynchronous testing

- (void)enableAsyncTestingFirstStep;
- (void)enableAsyncTestingSecondStep;
- (void)enableAsyncTestingThirdStep;

@end
