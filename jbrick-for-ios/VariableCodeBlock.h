//
//  VariableCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodeBlock.h"
#import "PrimativeTypeUtility.h"
#import "VariableDeclorationBlock.h"

@interface VariableCodeBlock : CodeBlock <CodeBlockDelegate>
{
    VariableDeclorationBlock *variable;
    NSMutableArray *parents;
}
@property (readonly) NSInteger ReferenceCount;
-(id) init:(VariableDeclorationBlock *)name type:(Primative)primitive;
-(void) removeParent:(CodeBlock *)parent;
@end
