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
    JPImgurClient *client;
    NSDictionary *imgurIDExamples;
}

- (dispatch_semaphore_t)enableAsyncTestingFirstStep;
- (void)enableAsyncTestingSecondStep:(dispatch_semaphore_t)semaphore;
- (void)enableAsyncTestingThirdStep:(dispatch_semaphore_t)semaphore;

@end
