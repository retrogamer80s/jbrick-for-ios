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

-(void) placeBlock:(UIView *)block;
-(UIBlock *) createNewProgram;
-(void) saveProgram:(NSString *)name;
-(void) loadNewProgram:(NSString *)name;

@end
