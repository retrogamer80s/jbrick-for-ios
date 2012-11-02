//
//  VariableCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VariableCodeBlock.h"
#import "ConstantValueBlocks.h"

@implementation VariableCodeBlock
@synthesize ReturnType;
@synthesize Deleted;

-(id) init:(VariableDeclorationBlock *)variableParam type:(Primative)primitive
{
    self = [super init];
    variable = variableParam;
    self.ReturnType = primitive;
    parents = [NSMutableArray array];
    return self;
}

-(id<CodeBlock>)Parent{
    if(parents.count > 0)
        return [parents objectAtIndex:0];
    else
        return nil;
}
-(void)setParent:(id<CodeBlock>)Parent
{
    [parents addObject:Parent];
}
-(void) removeParent:(id<CodeBlock>)parent
{
    [parents removeObject:parent];
}

-(bool)Deleted {
    return deleted || variable.Deleted;
}

-(NSInteger)ReferenceCount {
    
    for(id<CodeBlock> parent in [parents copy])
        if(parent.Deleted)
            [parents removeObject:parent];
    
    return parents.count;
}

- (NSString *) generateCode
{
    if(!Deleted && variable && !variable.Deleted && variable.ReturnType == ReturnType)
        return variable.Name;
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
    [self.Parent removeCodeBlock:self];
}

-(void)removeCodeBlock:(id<CodeBlock>)codeBlock
{
    // Variable blocks don't have children and thus can't remove them
}

- (NSArray *) getAvailableParameters:(Primative)type
{
    NSMutableArray *params = [NSMutableArray array];
    [self.Parent addAvailableParameters:type parameterList:params beforeIndex:self];
    [params addObjectsFromArray:[ConstantValueBlocks getValueConstants:type]];
    return params;
}
- (void) addAvailableParameters:(Primative)type parameterList:(NSMutableArray *)paramList beforeIndex:(id<CodeBlock>)index
{
    // This method should only be called from child blocks, and this type of block has no children
}

- (id<CodeBlock>) getParameterReferenceBlock:(Primative)type
{
    return nil; // Currently we are not supporting using non-variable blocks as parameters of other blocks
}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitVariableCodeBlock:self];
}

@end
