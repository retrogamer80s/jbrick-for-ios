//
//  MethodDeclorationBlock.h
//  jbrick-for-ios
//
//  Created by Student on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewableCodeBlock.h"
#import "VariableCodeBlock.h"
#import "PrimativeTypeUtility.h"

@interface MethodDeclorationBlock : ViewableCodeBlock
{
    NSString *name;
    NSMutableArray *parameterValues;
    NSMutableArray *parameterTypes;
    NSMutableArray *innerCodeBlocks;
}

+(id) getMainBlock;
-(id) init:(NSString *)name parameterTypes:(NSMutableArray *)parameters returnType:(Primative)returnType;
@end
