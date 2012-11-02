//
//  MethodDeclorationBlock.m
//  jbrick-for-ios
//
//  Created by Student on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MethodDeclorationBlock.h"
#import "ConstantValueBlocks.h"

@implementation MethodDeclorationBlock
@synthesize ReturnType;
@synthesize Parent;
@synthesize Deleted;
@synthesize BlockColor;
@synthesize Icon;

static MethodDeclorationBlock *mainBlock;

-(id) init:(NSString *)methodName parameterVariables:(NSMutableArray *)parameters returnType:(Primative)returnType
{
    self = [super init];
    name = methodName;
    ReturnType = returnType;
    parameterVariables = parameters;
    innerCodeBlocks = [[NSMutableArray alloc]init];
    return self;
}

+(id) getMainBlock
{
    if(!mainBlock){
        mainBlock = [[MethodDeclorationBlock alloc] init:@"main" parameterVariables:[NSArray array] returnType:MAIN];
    }
    return mainBlock;
}

-(NSString *)generateCode
{
    // The end result should look like "void sum(int variable1, int variable2){ return variable1+variable2; }"
    NSMutableString *generatedCode = [[NSMutableString alloc] initWithString:[PrimativeTypeUtility primativeToString:ReturnType]];
    [generatedCode appendFormat:@" %@(", name];
    NSArray *paramValues = [self getParameterDeclorations];
    for(int i=0; i<[paramValues count]; i++ ){
        [generatedCode appendString:[paramValues objectAtIndex:i]];
        if (i < [paramValues count] - 1)
            [generatedCode appendString:@","];
    }
    [generatedCode appendString:@"){"];
    
    for(id<CodeBlock> statement in innerCodeBlocks){
        [generatedCode appendString:[statement generateCode]];
    }
    [generatedCode appendString:@"}"];
    
    return generatedCode;
}

-(bool)addCodeBlock:(id<CodeBlock>)codeBlock
{
    codeBlock.Parent = self;
    [innerCodeBlocks addObject:codeBlock];
    return true;
}

-(bool)addCodeBlock:(id<CodeBlock>)codeBlock indexBlock:(id<CodeBlock>)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    NSInteger insertIndex = [innerCodeBlocks indexOfObject:indexBlock];
    if(insertIndex == NSNotFound)
        return false;
    
    codeBlock.Parent = self;
    if(afterIndexBlock)
        [innerCodeBlocks insertObject:codeBlock atIndex:insertIndex+1];
    else
        [innerCodeBlocks insertObject:codeBlock atIndex:insertIndex];
    return true;
}

-(UIView *) getPropertyView
{
    return [[UITextView alloc] init];
}

-(NSString *) getDisplayName
{
    return name;
}

-(id<ViewableCodeBlock>) getPrototype
{
    MethodDeclorationBlock *prototype = [[MethodDeclorationBlock alloc] init:name parameterVariables:parameterVariables returnType:ReturnType];
    prototype.BlockColor = BlockColor;
    prototype.Icon = Icon;
    return prototype;    
}

-(void)removeFromParent
{
    [Parent removeCodeBlock:self];
}

-(void)removeCodeBlock:(id<CodeBlock>)codeBlock
{
    [innerCodeBlocks removeObject:codeBlock];
}

-(NSArray *) getPropertyVariables
{
    return parameterVariables;
}

- (NSArray *) getAvailableParameters:(Primative)type
{
    NSMutableArray *params = [NSMutableArray array];
    [Parent addAvailableParameters:type parameterList:params beforeIndex:self];
    [params addObjectsFromArray:[ConstantValueBlocks getValueConstants:type]];
    return params;
}
- (void) addAvailableParameters:(Primative)type parameterList:(NSMutableArray *)paramList beforeIndex:(id<CodeBlock>)index
{
    for(id<CodeBlock> codeBlock in innerCodeBlocks)
    {
        if(codeBlock == index)
            break;
        id<CodeBlock> paramRef = [codeBlock getParameterReferenceBlock:type];
        if(paramRef)
            [paramList addObject:paramRef];
    }
    
    if(Parent)
        [Parent addAvailableParameters:type parameterList:paramList beforeIndex:self];
}

- (id<CodeBlock>) getParameterReferenceBlock:(Primative)type
{
    return nil; // Currently we are not supporting using non-variable blocks as parameters of other blocks
}

-(NSArray *)getParameterDeclorations
{
    NSMutableArray *declorations = [[NSMutableArray alloc] initWithCapacity:[parameterVariables count]];
    for (int i = 0; i<[parameterVariables count]; i++) {
        VariableCodeBlock *variable = [parameterVariables objectAtIndex:i];
        NSString *primTypeString = [PrimativeTypeUtility primativeToString:variable.ReturnType];
        NSString *variableString = [variable generateCode];
        
        [declorations addObject:[NSString stringWithFormat:@"%@ %@", primTypeString, variableString]];
    }
    return declorations;
}

- (bool) replaceParameter:(id<CodeBlock>)oldParam newParameter:(id<CodeBlock>)newParam
{
    NSInteger index = [parameterVariables indexOfObject:oldParam];
    if(index == NSNotFound)
        return false;
    
    if(oldParam.ReturnType == newParam.ReturnType)
    {
        [parameterVariables replaceObjectAtIndex:index withObject:newParam];
        [((VariableCodeBlock *)oldParam) removeParent:self]; // If it's not a variableCodeBlock this call will do nothing
        newParam.Parent = self;
        return true;
    }
    
    return false;
}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitMethodDeclorationBlock:self];
}

@end
