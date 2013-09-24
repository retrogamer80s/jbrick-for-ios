//
//  jbrickServerUtility.h
//  jbrick-for-ios
//
//  Created by Student on 4/30/13.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

/**
 * Utility class for accessing information from the server
 */
@interface jbrickServerUtility : NSObject {
    AFHTTPClient *httpClient;
}

/**
 * Uploads the given source code to the server and sends it to the specified robot
 * once compiled.
 * @param name The name of the program which will be added to the robot
 * @param src The source code to be compiled
 * @param robotID The ID of the robot to send the application to
 */
- (void) uploadProgram:(NSString *)name withSource:(NSString *)src toRobot:(NSString *)robotID;

/**
 * Runs a given program on the specified robot
 * @param name The name of the program on the robot to run
 * @param robotID The ID of the robot to tell to run the program
 */
- (void) runProgram:(NSString *)name onRobot:(NSString *)robotID;

/**
 * Stops any running program on the speicfied robot
 * @param robotID The ID of the robot to send the command to
 */
- (void) stopProgramOnRobot:(NSString *)robotID;

/**
 * Get a list of all Robots connected to the server.
 * @param success The command to execute upon successful retrieval of the robots
 * @param failure The command to execute if the list of robots cannot be retrieved
 */
- (void) getRobots:(void (^)(NSArray *robots))success
                            failure:(void (^)(NSString *err))failure;
@end
