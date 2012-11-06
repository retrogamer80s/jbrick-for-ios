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


@interface ValuePickerController : UITableViewController <ValueInputCellDelegate>
{
    NSArray *availableCodeBlocks;
    VariableAssignmentDelegate *varDel;
    NSInteger listSizeModifier;
    UIView *inputCellView;
    CodeBlock * newParamBlock;
}

@property (nonatomic, assign) id<ValuePickerDelegate> delegate;
@property (nonatomic, assign) CodeBlock * parentCodeBlock;
@property (nonatomic, assign) CodeBlock * valueCodeBlock;

@end
