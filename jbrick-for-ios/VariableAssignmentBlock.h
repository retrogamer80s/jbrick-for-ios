//
//  VariableAssignmentBlock.h
//  jbrick-for-ios
//
//  Created by Student on 10/30/12.
//
//

#import <Foundation/Foundation.h>
#import "ViewableCodeBlock.h"
#import "VariableCodeBlock.h"

@interface VariableAssignmentBlock : CodeBlock <ViewableCodeBlock>
{
    VariableCodeBlock * variableReference;
    CodeBlock * parameterVariable;
    CodeBlock * innerCodeBlock;
}
@end
