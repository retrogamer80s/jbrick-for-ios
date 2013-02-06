//
//  VariableMathBlock.h
//  jbrick-for-ios
//
//  Created by Student on 11/6/12.
//
//

#import "ViewableCodeBlock.h"
#import "VariableCodeBlock.h"

@interface VariableMathBlock : CodeBlock <ViewableCodeBlock>
{
    VariableCodeBlock *variableReference;
    CodeBlock *parameterVariable;
    CodeBlock *mathOpBlock;
    NSMutableArray *innerCodeBlocks;
}
@end
