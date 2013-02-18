//
//  LogicalOperatorCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 2/18/13.
//
//

#import "CompositeCodeBlock.h"
#import "ViewableCodeBlock.h"

@interface LogicalOperatorCodeBlock : CompositeCodeBlock<ViewableCodeBlock>{
    NSString *name;
    CodeBlock *operation;
}
@end
