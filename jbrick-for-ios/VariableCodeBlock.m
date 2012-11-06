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

-(id) init:(VariableDeclorationBlock *)variableParam type:(Primative)primitive
{
    self = [super init];
    variable = variableParam;
    self.ReturnType = primitive;
    parents = [NSMutableArray array];
    return self;
}

-(CodeBlock *)Parent{
    if(parents.count > 0)
        return [parents objectAtIndex:0];
    else
        return nil;
}
-(void)setParent:(CodeBlock *)Parent
{
    [parents addObject:Parent];
}
-(void) removeParent:(CodeBlock *)parent
{
    [parents removeObject:parent];
}

- (void)setReturnType:(Primative)ReturnType
{
    super.ReturnType = ReturnType;
    for(CodeBlock *referenced in parents)
        [referenced childRequestChangeType:self prevType:returnType newType:ReturnType];
}

-(bool)Deleted {
    return deleted || variable.Deleted;
}

-(NSInteger)ReferenceCount {
    
    for(CodeBlock * parent in [parents copy])
        if(parent.Deleted)
            [parents removeObject:parent];
    
    return parents.count;
}

- (NSString *) generateCode
{
    if(!self.Deleted && variable && !variable.Deleted && variable.InternalType == self.ReturnType)
        return variable.Name;
    else 
        return [PrimativeTypeUtility getDefaultValue:self.ReturnType];
}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitVariableCodeBlock:self];
}

@end
