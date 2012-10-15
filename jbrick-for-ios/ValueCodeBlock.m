//
//  ValueCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ValueCodeBlock.h"
#import "PrimativeTypeUtility.h"

@implementation ValueCodeBlock
@synthesize ReturnType;
@synthesize Value;
@synthesize Deleted;
@synthesize Parent;

-(id) init:(Primative)type
{
    return [self init:type value:nil];
}

-(id)init:(Primative)type value:(NSString *)value
{
    self = [super init];
    ReturnType = type;
    Value = value;
    return self;
}

-(NSString *) generateCode
{
    if(Value){
        if(ReturnType == STRING)
            return [NSString stringWithFormat:@"\"%@\"", Value];
    
        return Value;
    } else {
        return [PrimativeTypeUtility getDefaultValue:ReturnType];
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

@end
