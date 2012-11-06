//
//  VariableAssignmentBlock.h
//  jbrick-for-ios
//
//  Created by Student on 10/30/12.
//
//

#import <Foundation/Foundation.h>
#import "ViewableCodeBlock.h"

@interface VariableAssignmentBlock : ViewableCodeBlock
{
    CodeBlock * variableReference;
    CodeBlock * parameterVariable;
    CodeBlock * innerCodeBlock;
}
@end
