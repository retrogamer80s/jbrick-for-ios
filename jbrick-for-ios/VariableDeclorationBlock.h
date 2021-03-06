//
//  VariableDeclorationBlock.h
//  jbrick-for-ios
//
//  Created by Student on 10/17/12.
//
//

#import <Foundation/Foundation.h>
#import "ViewableCodeBlock.h"
#import "CompositeCodeBlock.h"
#import "ValueCodeBlock.h"

@interface VariableDeclorationBlock : CompositeCodeBlock <ViewableCodeBlock>
{
    ValueCodeBlock *name;
    ValueCodeBlock *type;
    CodeBlock * varReference;
    NSArray *paramNames;
}
@property (readonly) NSString *Name;
@property Primative InternalType;
-(id) init:(NSString *)variableName type:(Primative)returnType;
@end