//
//  ValuePickerController.h
//  jbrick-for-ios
//
//  Created by Student on 10/15/12.
//
//

#import <UIKit/UIKit.h>
#import "CodeBlock.h"
#import "PrimativeTypeUtility.h"
#import "CodeBlock.h"
#import "ValueCodeBlock.h"
#import "VariableCodeBlock.h"
#import "ValueInputCell.h"

@protocol ValuePickerDelegate <UIAlertViewDelegate>
- (void)didSelectValue:(CodeBlock *)codeBlock previousCodeBlock:(CodeBlock *)prevCodeBlock;
@end

/** This is the UI popup for selecting a variable or constant value for a block */
@interface ValuePickerController : UITableViewController <ValueInputCellDelegate>
{
    NSArray *availableCodeBlocks;
    VariableAssignmentDelegate *varDel;
    NSInteger listSizeModifier;
    UIView *inputCellView;
    CodeBlock * newParamBlock;
}

/** The delagate that is notified when a value has been selected */
@property (nonatomic, assign) id<ValuePickerDelegate> delegate;
/** The parent code block that will receive the selected block */
@property (nonatomic, assign) CodeBlock * parentCodeBlock;
/** The currently selected valueCodeBlock */
@property (nonatomic, assign) CodeBlock * valueCodeBlock;

@end
