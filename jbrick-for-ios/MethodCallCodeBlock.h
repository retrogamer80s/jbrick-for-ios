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

@interface MethodCallCodeBlock : ViewableCodeBlock{
    NSString *name;
    NSMutableArray *parameterValues;
    NSArray *parameterTypes;
}
-(id) init:(NSString *)methodName parameterTypes:(NSArray *)parameters returnType:(Primative)returnType;
-(void) setVariable:(CodeBlock *)variable index:(NSInteger)index;
@end
