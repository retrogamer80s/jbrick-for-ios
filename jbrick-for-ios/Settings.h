//
//  Settings.h
//  jbrick-for-ios
//
//  Created by Student on 3/28/13.
//
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject{
    NSUserDefaults *userDefaults;
    NSString *saveDir;
    NSString *saveExt;
}
+(Settings *) settings;
-(id) init;
@property NSString *RobotID;
@property NSString *CurrentProgram;
@property (readonly) NSString *SaveDirectory;
@property (readonly) NSString *SaveExtention;
@end
