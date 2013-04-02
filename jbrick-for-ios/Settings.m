//
//  Settings.m
//  jbrick-for-ios
//
//  Created by Student on 3/28/13.
//
//

#import "Settings.h"

static Settings *singleton;

@implementation Settings
+(Settings *) settings { return [[Settings alloc] init]; }
-(id) init
{
    if(!singleton){
        self = [super init];
        userDefaults = [NSUserDefaults standardUserDefaults];
        singleton = self;
    }
        return singleton;
}

- (NSString *)RobotID{
    NSString *result = [userDefaults objectForKey:@"RobotID"];
    if(!result)
        result = @"";
    return result;
    
}
- (void)setRobotID:(NSString *)RobotID{
    [userDefaults setObject:RobotID forKey:@"RobotID"];
}

- (NSString *)CurrentProgram{
    NSString *result = [userDefaults objectForKey:@"CurrentProgram"];
    if(!result)
        result = @"First Program";
    return result;
}
- (void)setCurrentProgram:(NSString *)CurrentProgram{
    [userDefaults setObject:CurrentProgram forKey:@"CurrentProgram"];
}

- (NSString *)SaveDirectory{
    if(!saveDir)
        saveDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return saveDir;
}

- (NSString *)SaveExtention{
    if(!saveExt)
        saveExt = @".sav";
    return saveExt;
}

@end
