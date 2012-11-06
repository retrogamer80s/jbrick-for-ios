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
    Boolean canChange = true;
    if(self.Parent)
        canChange = [self.Parent childRequestChangeType:self prevType:returnType newType:ReturnType];
    
    if(canChange){
        returnType = ReturnType;
        valueBlock = [[ValueCodeBlock alloc] init:ReturnType];
    }
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

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitValueCodeBlock:self];
}

-(NSString *)getDisplayName{
    return @"Value";
}

-(ViewableCodeBlock *)getPrototype{
    ValueCodeBlock *block = [[ValueCodeBlock alloc] init:returnType];
    block.BlockColor = self.BlockColor;
    block.Icon = self.Icon;
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

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{
    
    if(oldParam.ReturnType == PARAMETER_RETURN && newParam.ReturnType != returnType){
        
        Boolean canChange = true;
        if(self.Parent)
            canChange = [self.Parent childRequestChangeType:self prevType:returnType newType:newParam.ReturnType];
        
        if(canChange){
            returnType = newParam.ReturnType;
            type = [[ValueCodeBlock alloc] init:PARAMETER_RETURN value:[PrimativeTypeUtility primativeToName:returnType]];
            valueBlock = [[ValueCodeBlock alloc] init:returnType];
        }
        
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
