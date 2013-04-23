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
#import "CompositeCodeBlock.h"

@interface MethodDeclorationBlock : CompositeCodeBlock<ViewableCodeBlock>
{
    NSString *name;
    NSMutableArray *parameterValues;
    NSMutableArray *parameterTypes;
    NSArray *parameterNames;
}

+(id) getMainBlock;
+(id) createNewMainBlock;
-(id) init:(NSString *)methodName description:(NSString *)desc parameterTypes:(NSMutableArray *)parameters
                       parameterNames:(NSArray *)paramNames returnType:(Primative)returnTypeParam;
@end
