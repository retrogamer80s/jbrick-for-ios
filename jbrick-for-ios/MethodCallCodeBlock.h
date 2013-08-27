//
//  MethodCallCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewableCodeBlock.h"
#import "VariableCodeBlock.h"
#import "PrimativeTypeUtility.h"

@interface MethodCallCodeBlock : CodeBlock <ViewableCodeBlock>{
    NSString *name;
    NSMutableArray *parameterValues;
    NSArray *parameterTypes;
    NSArray *parameterNames;
}
-(id) init:(NSString *)methodName description:(NSString *)desc parameterTypes:(NSArray *)parameters
                       parameterNames:(NSArray *)paramNames returnType:(Primative)returnTypeParam;
-(void) setVariable:(CodeBlock *)variable index:(NSInteger)index;
@end
