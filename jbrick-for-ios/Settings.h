//
//  Settings.h
//  jbrick-for-ios
//
//  Created by Student on 3/28/13.
//
//

#import <Foundation/Foundation.h>

/** A singleton utility object used to retrieve and set program settings */
@interface Settings : NSObject{
    NSUserDefaults *userDefaults;
    NSString *saveDir;
    NSString *saveExt;
}
+(Settings *) settings;
-(id) init;
/** The ID of the last selected NXT Robot */
@property NSString *RobotID;
/** The name of the last selected Program */
@property NSString *CurrentProgram;
/** The directory to save programs into */
@property (readonly) NSString *SaveDirectory;
/** The extention to save programs with */
@property (readonly) NSString *SaveExtention;
@end
