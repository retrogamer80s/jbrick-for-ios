//
//  ValueCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ValueCodeBlock.h"
#import "PrimativeTypeUtility.h"
#import "ConstantValueBlocks.h"

@implementation ValueCodeBlock
@synthesize Value;
@synthesize Deleted;
@synthesize Parent;
@synthesize BlockColor;
@synthesize Icon;

-(id) init:(Primative)typeParam
{
    return [self init:typeParam value:nil];
}

-(id)init:(Primative)typeParam value:(NSString *)valueParam
{
    self = [super init];
    returnType = typeParam;
    Value = valueParam;
    return self;
}

- (Primative)ReturnType{ return returnType; }
- (void)setReturnType:(Primative)ReturnType
{
    returnType = ReturnType;
    valueBlock = [[ValueCodeBlock alloc] init:ReturnType];
}

-(NSString *) generateCode
{
    if(!valueBlock){
        if(Value){
            if(returnType == STRING)
                return [NSString stringWithFormat:@"\"%@\"", Value];
            
            return Value;
        } else {
            return [PrimativeTypeUtility getDefaultValue:returnType];
        }
    } else {
        return [valueBlock generateCode];
    }
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
    // Method call blocks don't have children and thus can't remove them
}

- (NSArray *) getAvailableParameters:(Primative)typeParam
{
    NSMutableArray *params = [NSMutableArray array];
    [Parent addAvailableParameters:typeParam parameterList:params beforeIndex:self];
    [params addObjectsFromArray:[ConstantValueBlocks getValueConstants:typeParam]];
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
    [visitor visitValueCodeBlock:self];
}


-(NSString *)getDisplayName{
    return @"Value";
}

-(id<ViewableCodeBlock>)getPrototype{
    ValueCodeBlock *block = [[ValueCodeBlock alloc] init:returnType];
    block.BlockColor = BlockColor;
    block.Icon = Icon;
    return block;
}
-(NSArray *) getPropertyVariables
{
    if(!type)
        type = [[ValueCodeBlock alloc] init:PARAMETER_RETURN value:[PrimativeTypeUtility primativeToName:returnType]];
    if(!valueBlock)
        valueBlock = [[ValueCodeBlock alloc] init:returnType];
    return [NSArray arrayWithObjects:type, valueBlock, nil];
}

- (bool) replaceParameter:(id<CodeBlock>)oldParam newParameter:(id<CodeBlock>)newParam
{
    
    if(oldParam.ReturnType == PARAMETER_RETURN && newParam.ReturnType != returnType){
        returnType = newParam.ReturnType;
        type = [[ValueCodeBlock alloc] init:PARAMETER_RETURN value:[PrimativeTypeUtility primativeToName:returnType]];
        valueBlock = [[ValueCodeBlock alloc] init:returnType];
        
        return true;
    } else if(oldParam.ReturnType != PARAMETER_RETURN && newParam.ReturnType == returnType) {
        newParam.Parent = self;
        valueBlock = newParam;
    } else {
        return false;
    }
    
    return false;

}


@end
