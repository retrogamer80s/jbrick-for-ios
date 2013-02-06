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
@synthesize BlockColor;
@synthesize Icon;
@synthesize ContainsChildren;

static MethodDeclorationBlock *mainBlock;

-(id) init:(NSString *)methodName parameterTypes:(NSMutableArray *)parameters returnType:(Primative)returnTypeParam
{
    self = [super init];
    name = methodName;
    self.ReturnType = returnTypeParam;
    
    parameterTypes = parameters;
    parameterValues = [NSMutableArray arrayWithCapacity:[parameters count]];
    for(int i=0; i<[parameterTypes count]; i++)
        [parameterValues addObject:[[ValueCodeBlock alloc] init:[[parameters objectAtIndex:i] integerValue]]];
    
    innerCodeBlocks = [[NSMutableArray alloc]init];
    self.ContainsChildren = YES;
    return self;
}

+(id) getMainBlock
{
    if(!mainBlock){
        mainBlock = [[MethodDeclorationBlock alloc] init:@"main" parameterTypes:[NSArray array] returnType:MAIN];
    }
    return mainBlock;
}

-(NSString *)generateCode
{
    // The end result should look like "void sum(int variable1, int variable2){ return variable1+variable2; }"
    NSMutableString *generatedCode = [[NSMutableString alloc] initWithString:[PrimativeTypeUtility primativeToString:self.ReturnType]];
    [generatedCode appendFormat:@" %@(", name];
    NSArray *paramValues = [self getParameterDeclorations];
    for(int i=0; i<[paramValues count]; i++ ){
        [generatedCode appendString:[paramValues objectAtIndex:i]];
        if (i < [paramValues count] - 1)
            [generatedCode appendString:@","];
    }
    [generatedCode appendString:@"){"];
    
    for(CodeBlock * statement in innerCodeBlocks){
        [generatedCode appendString:[statement generateCode]];
    }
    [generatedCode appendString:@"}"];
    
    return generatedCode;
}

-(bool)addCodeBlock:(CodeBlock *)codeBlock
{
    [innerCodeBlocks addObject:codeBlock];
    codeBlock.Parent = self;
    return true;
}

-(bool)addCodeBlock:(CodeBlock *)codeBlock indexBlock:(CodeBlock *)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    NSInteger insertIndex = [innerCodeBlocks indexOfObject:indexBlock];
    if(insertIndex == NSNotFound)
        return false;
    
    if(afterIndexBlock)
        [innerCodeBlocks insertObject:codeBlock atIndex:insertIndex+1];
    else
        [innerCodeBlocks insertObject:codeBlock atIndex:insertIndex];     codeBlock.Parent = self;
    
    return true;
}

-(NSString *) getDisplayName
{
    return name;
}

-(id<ViewableCodeBlock>) getPrototype
{
    MethodDeclorationBlock *prototype = [[MethodDeclorationBlock alloc] init:name parameterTypes:parameterTypes returnType:self.ReturnType];
    prototype.BlockColor = self.BlockColor;
    prototype.Icon = self.Icon;
    return prototype;    
}

-(void)removeCodeBlock:(CodeBlock *)codeBlock
{
    [innerCodeBlocks removeObject:codeBlock];
}

-(NSArray *) getPropertyVariables
{
    return parameterValues;
}

-(bool) parameterIsInScope:(CodeBlock *)parameter beforeIndex:(CodeBlock *)index
{
    int paramIndex = [innerCodeBlocks indexOfObject:parameter];
    int indexIndex = [innerCodeBlocks indexOfObject:index];
    
    if(paramIndex != NSNotFound && indexIndex != NSNotFound)
        return paramIndex < indexIndex;
    else
        return [super parameterIsInScope:parameter beforeIndex:index];
}

- (void) addAvailableParameters:(Primative)type parameterList:(NSMutableArray *)paramList beforeIndex:(CodeBlock *)index
{
    for(CodeBlock * codeBlock in innerCodeBlocks)
    {
        if(codeBlock == index)
            break;
        CodeBlock * paramRef = [codeBlock getParameterReferenceBlock:type];
        if(paramRef)
            [paramList addObject:paramRef];
    }
    
    if(self.Parent)
        [self.Parent addAvailableParameters:type parameterList:paramList beforeIndex:self];
}

-(NSArray *)getParameterDeclorations
{
    NSMutableArray *declorations = [[NSMutableArray alloc] initWithCapacity:[parameterValues count]];
    for (int i = 0; i<[parameterValues count]; i++) {
        VariableCodeBlock *variable = [parameterValues objectAtIndex:i];
        NSString *primTypeString = [PrimativeTypeUtility primativeToString:variable.ReturnType];
        NSString *variableString = [variable generateCode];
        
        [declorations addObject:[NSString stringWithFormat:@"%@ %@", primTypeString, variableString]];
    }
    return declorations;
}

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{
    NSInteger index = [parameterValues indexOfObject:oldParam];
    if(index == NSNotFound)
        return false;
    
    if(oldParam.ReturnType == newParam.ReturnType)
    {
        [parameterValues replaceObjectAtIndex:index withObject:newParam];
        if([oldParam isKindOfClass:[VariableCodeBlock class]])
            [((VariableCodeBlock *)oldParam) removeParent:self];
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
