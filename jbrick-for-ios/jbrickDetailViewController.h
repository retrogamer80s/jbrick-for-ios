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

@interface jbrickDetailViewController : UIViewController <UISplitViewControllerDelegate, UIGestureRecognizerDelegate>{
    UIPopoverController *popoverController;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet PropertyViewController *propertyPane;
@property (weak, nonatomic) IBOutlet UITextField *ProgramName;
@property (strong, nonatomic) MGSplitViewController *splitViewController;
@property (weak, nonatomic) IBOutlet ProgramPane *programPane;

/**
 * Places the UIBlock into the program pane and initializes
 * the process of snapping it to the grid.
 * @param block the UIBlock to add to the program pane
 */
-(void) placeBlock:(UIView *)block;

/**
 * Refreshes the program pane with a new program.
 * @return the new top level block, typicaly the Main block.
 */
-(UIBlock *) createNewProgram;

/**
 * Saves the current program with the given name.
 * @param name The name to save the program under
 */
-(void) saveProgram:(NSString *)name;

/**
 * Loads in the program with the given name.
 * @param name The name of the program to load in
 */
-(void) loadNewProgram:(NSString *)name;

@end
