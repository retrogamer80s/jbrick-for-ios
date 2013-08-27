//
//  jbrickServerUtility.m
//  jbrick-for-ios
//
//  Created by Student on 4/30/13.
//
//

#import "jbrickServerUtility.h"
#import "AFJSONRequestOperation.h"

@implementation jbrickServerUtility

- (id)init{
    self = [super init];
    NSURL *url = [NSURL URLWithString:@"http://link.se.rit.edu/rest/"];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    return self;
}

- (void) uploadProgram:(NSString *)name withSource:(NSString *)src toRobot:(NSString *)robotID{

    httpClient.parameterEncoding = AFJSONParameterEncoding;
    httpClient.stringEncoding = NSUTF16StringEncoding;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            src, @"src",
                            name, @"filename",
                            nil];
    [httpClient postPath:[NSString stringWithFormat:@"Devices/%@/compile", robotID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

- (void) runProgram:(NSString *)name onRobot:(NSString *)robotID {
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name, @"program",
                            nil];
    [httpClient getPath:[NSString stringWithFormat:@"Devices/%@/RunProgram", robotID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

- (void) stopProgramOnRobot:(NSString *)robotID {
    [httpClient getPath:[NSString stringWithFormat:@"Devices/%@/StopProgram", robotID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

- (void) getRobots:(void (^)(NSArray *robots))success
                            failure:(void (^)(NSString *err))failure{
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient  getPath:@"Devices" parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id JSON) {
                     NSString *responseStr = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
                     NSLog(@"Request Successful, response '%@'", responseStr);
                     
                     id jsonRobots = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONWritingPrettyPrinted error:nil];
                     NSArray *robots =  [NSArray arrayWithArray:jsonRobots];
                     
                     if(success)
                         success(robots);
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
                     if(failure)
                         failure(error.localizedDescription);
                 }];


}
@end
