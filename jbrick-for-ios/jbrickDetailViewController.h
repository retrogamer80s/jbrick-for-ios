//
//  jbrickDetailViewController.h
//  jbrick-for-ios
//
//  Created by Student on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramPane.h"
#import "MGSplitViewController.h"
#import "PropertyViewController.h"
#import "RobotPickerController.h"

@interface jbrickDetailViewController : UIViewController <UISplitViewControllerDelegate, UIGestureRecognizerDelegate, RobotPickerDelegate>{
    NSString *robotID;
    RobotPickerController *picker;
    UIPopoverController *popoverController;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet PropertyViewController *propertyPane;
@property (weak, nonatomic) IBOutlet ProgramPane *programPane;
@property (weak, nonatomic) IBOutlet UIButton *SelectRobotButton;
@property (strong, nonatomic) MGSplitViewController *splitViewController;

-(void) placeBlock:(UIView *)block;

@end
