//
//  VariableAssignmentBlock.h
//  jbrick-for-ios
//
//  Created by Student on 10/30/12.
//
//

#import <Foundation/Foundation.h>
#import "ViewableCodeBlock.h"

@interface VariableAssignmentBlock : NSObject <ViewableCodeBlock>
{
    id<CodeBlock> variableReference;
    id<CodeBlock> innerCodeBlock;
    NSMutableArray *parameters;
}
@end
