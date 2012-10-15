//
//  PropertyViewController.h
//  jbrick-for-ios
//
//  Created by Student on 10/12/12.
//
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"
#import "ValuePickerController.h"

@interface PropertyViewController : UITableViewController
{
    NSArray *variables;
    ValuePickerController *valuePicker;
    UIPopoverController *popoverController;
}
@property MGSplitViewController *splitViewController;
@property (readonly) BOOL isOpen;

-(void)setPropertyContent:(NSArray *) variables;
-(void)closePanel:(void (^)(BOOL finished))completion;
-(void)openPanel:(void (^)(BOOL finished))completion;
@end
