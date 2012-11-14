//
//  VariableMathBlock.h
//  jbrick-for-ios
//
//  Created by Student on 11/6/12.
//
//

#import "ViewableCodeBlock.h"

@interface VariableMathBlock : ViewableCodeBlock
{
    CodeBlock *variableReference;
    CodeBlock *parameterVariable;
    CodeBlock *mathOpBlock;
    NSMutableArray *innerCodeBlocks;
}
@end
