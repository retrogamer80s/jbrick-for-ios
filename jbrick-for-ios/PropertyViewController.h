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
#import "ViewableCodeBlock.h"

@interface PropertyViewController : UITableViewController <ValuePickerDelegate, ValueInputCellDelegate>
{
    NSArray *variables;
    ValuePickerController *valuePicker;
    UIPopoverController *popoverController;
    id<ViewableCodeBlock> codeBlock;
    NSMutableDictionary *varDelegates;
}
@property MGSplitViewController *splitViewController;
@property (readonly) BOOL isOpen;

-(void)setPropertyContent:(id<ViewableCodeBlock>) codeBlock;
-(void)closePanel:(void (^)(BOOL finished))completion;
-(void)openPanel:(void (^)(BOOL finished))completion;
@end
