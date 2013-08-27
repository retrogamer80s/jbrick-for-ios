//
//  jbrickServerUtility.h
//  jbrick-for-ios
//
//  Created by Student on 4/30/13.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface jbrickServerUtility : NSObject {
    AFHTTPClient *httpClient;
}
- (void) uploadProgram:(NSString *)name withSource:(NSString *)src toRobot:(NSString *)robotID;
- (void) runProgram:(NSString *)name onRobot:(NSString *)robotID;
- (void) stopProgramOnRobot:(NSString *)robotID;
- (void) getRobots:(void (^)(NSArray *robots))success
                            failure:(void (^)(NSString *err))failure;
@end
