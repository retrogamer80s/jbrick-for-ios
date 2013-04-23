//
//  WhileLoopCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 2/18/13.
//
//

#import "CompositeCodeBlock.h"
#import "ViewableCodeBlock.h"

typedef enum LogicType {IF, WHILE} LogicType;

@interface WhileLoopCodeBlock : CompositeCodeBlock<ViewableCodeBlock>{
    NSString *name;
    NSString *src;
    CodeBlock *parameter;
    NSArray *paramNames;
}
@property LogicType logicType;

-(id) init:(LogicType)ifOrWhile;
@end
