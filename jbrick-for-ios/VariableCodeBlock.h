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

@interface VariableCodeBlock : NSObject <CodeBlock>
{
    NSString *name;
    Primative returnType;
}
-(id) init:(NSString *)name type:(Primative)primitive;
@end
