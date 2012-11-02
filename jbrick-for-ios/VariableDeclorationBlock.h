//
//  VariableDeclorationBlock.h
//  jbrick-for-ios
//
//  Created by Student on 10/17/12.
//
//

#import <Foundation/Foundation.h>
#import "ViewableCodeBlock.h"
#import "ValueCodeBlock.h"

@interface VariableDeclorationBlock : NSObject <ViewableCodeBlock>
{
    ValueCodeBlock *name;
    ValueCodeBlock *type;
    id<CodeBlock> varReference;
}
@property (readonly) NSString *Name;
-(id) init:(NSString *)variableName type:(Primative)returnType;
@end
