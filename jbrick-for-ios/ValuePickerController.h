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

@protocol ValuePickerDelegate
- (void)didSelectValue:(id<CodeBlock>)codeBlock;
@end


@interface ValuePickerController : UITableViewController
{
    NSArray *availableCodeBlocks;
}

@property (nonatomic, assign) id<ValuePickerDelegate> delegate;
@property (nonatomic, assign) id<CodeBlock> parentCodeBlock;
@property (nonatomic, assign) id<CodeBlock> valueCodeBlock;

@end
