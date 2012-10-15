//
//  VariableCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VariableCodeBlock.h"

@implementation VariableCodeBlock
@synthesize ReturnType;
@synthesize Parent;
@synthesize Deleted;

-(id) init:(NSString *)nameParam type:(Primative)primitive
{
    self = [super init];
    name = nameParam;
    self.ReturnType = primitive;
    return self;
}

- (NSString *) generateCode
{
    if(!Deleted)
        return name;
    else 
        return [PrimativeTypeUtility getDefaultValue:ReturnType];
}

-(bool)addCodeBlock:(id<CodeBlock>)codeBlock
{
    return false;
}

-(bool)addCodeBlock:(id<CodeBlock>)codeBlock indexBlock:(id<CodeBlock>)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    return false;
}

-(void)removeFromParent
{
    [Parent removeCodeBlock:self];
}

-(void)removeCodeBlock:(id<CodeBlock>)codeBlock
{
    // Variable blocks don't have children and thus can't remove them
}

@end
