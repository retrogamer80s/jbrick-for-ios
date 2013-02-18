//
//  VariableMathBlock.h
//  jbrick-for-ios
//
//  Created by Student on 11/6/12.
//
//

#import "ViewableCodeBlock.h"
#import "VariableCodeBlock.h"
#import "CompositeCodeBlock.h"

@interface VariableMathBlock : CompositeCodeBlock <ViewableCodeBlock>
{
    VariableCodeBlock *variableReference;
    CodeBlock *parameterVariable;
    CodeBlock *mathOpBlock;
}
@end
