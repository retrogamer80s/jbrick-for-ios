//
//  RobotPickerControllerViewController.h
//  jbrick-for-ios
//
//  Created by Student on 3/12/13.
//
//

#import <UIKit/UIKit.h>

@protocol RobotPickerDelegate <UIAlertViewDelegate>
- (void)didSelectRobot:(NSString *)robotID name:(NSString *)robotName;
@end

@interface RobotPickerController : UITableViewController {
    NSArray *robotIDs;
    NSArray *robotNames;
    NSString *selID;
}

@property (nonatomic, assign) id<RobotPickerDelegate> delegate;

- (id)init:(NSArray *)robotIDs names:(NSArray *)names selectedID:(NSString *)selID delegate:(id<RobotPickerDelegate>)del;

@end
