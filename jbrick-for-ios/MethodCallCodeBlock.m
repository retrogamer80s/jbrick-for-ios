//
//  MethodCallCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MethodCallCodeBlock.h"
#import "ValueCodeBlock.h"
#import "ConstantValueBlocks.h"

@implementation MethodCallCodeBlock
@synthesize ReturnType;
@synthesize Parent;
@synthesize Deleted;
@synthesize BlockColor;
@synthesize Icon;

int DEFAULT_MARGIN = 10;

-(id) init:(NSString *)methodName parameterTypes:(NSArray *)parameters returnType:(Primative)returnType
{
    self = [super init];
    name = methodName;
    ReturnType = returnType;
    parameterTypes = parameters;
    parameterValues = [NSMutableArray arrayWithCapacity:[parameters count]];
    for(int i=0; i<[parameterTypes count]; i++)
        [parameterValues addObject:[[ValueCodeBlock alloc] init:[[parameters objectAtIndex:i] integerValue]]];
    
    return self;
}

-(NSString *)generateCode
{
    if(!Deleted){
        // The end result should look like "name(variable1, variable2);"
        NSMutableString *generatedCode = [[NSMutableString alloc] initWithString:name];
        [generatedCode appendString:@"("];
        NSArray *paramValues = [self getParameterValues];
        for(int i=0; i<[paramValues count]; i++ ){
            [generatedCode appendString:[paramValues objectAtIndex:i]];
            if (i < [paramValues count] - 1)
                [generatedCode appendString:@","];
        }
        [generatedCode appendString:@");"];
        return generatedCode;
    } else {
        return [PrimativeTypeUtility getDefaultValue:ReturnType];
    }
}

-(void) setVariable:(id<CodeBlock>)variable index:(NSInteger)index
{
    [parameterValues replaceObjectAtIndex:index withObject:variable];
}

-(UIView *) getPropertyView
{
    // Construct a view to hold all subviews, it's frame will change with each view added
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    for (int i=0; i<parameterTypes.count; i++) {
        //UIView *subView = [PrimativeTypeUtility constructDefaultView:[[parameterTypes objectAtIndex:i] integerValue]];
        //subView.frame = CGRectMake(0, view.frame.size.height + 10, 0, subView.frame.size.height);
        //view.frame = CGRectMake(0, 0, 0, view.frame.size.height + subView.frame.size.height + DEFAULT_MARGIN*2);
        //[view addSubview:subView];
    }
    return view;
}

-(NSString *)getDisplayName{
    // For simplicity just return the method name for now
    // it would be easier for the user if methods had
    // friendly names instead
    return name;
}

-(id<ViewableCodeBlock>)getPrototype{
    MethodCallCodeBlock *block = [[MethodCallCodeBlock alloc] init:name parameterTypes:parameterTypes returnType:ReturnType];
    block.BlockColor = BlockColor;
    block.Icon = Icon;
    return block;
}

-(bool)addCodeBlock:(id<CodeBlock>)codeBlock
{
    return false; // Cannot add blocks to a call block
}

-(bool)addCodeBlock:(id<CodeBlock>)codeBlock indexBlock:(id<CodeBlock>)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    return false; // Cannot add blocks to a call block
}

-(void)removeFromParent
{
    [Parent removeCodeBlock:self];
}

-(void)removeCodeBlock:(id<CodeBlock>)codeBlock
{
    // Method call blocks don't have children and thus can't remove them
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
    // This method should only be called from child blocks, and this type of block has no children
}

- (id<CodeBlock>) getParameterReferenceBlock:(Primative)type
{
    return nil; // Currently we are not supporting using non-variable blocks as parameters of other blocks
}

//******** Private Methods ********

-(NSArray *) getPropertyVariables
{
    return parameterValues;
}

-(NSArray *)getParameterValues
{
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[parameterTypes count]];
    for (int i = 0; i<[parameterTypes count]; i++) {
        id<CodeBlock> variable = [parameterValues objectAtIndex:i];
        Primative primType = [[parameterTypes objectAtIndex:i] integerValue];
        // If the variable is assigned and of the right return type get it's code
        if(variable != (id)[NSNull null] && [variable ReturnType] == primType)
            [values addObject:[[parameterValues objectAtIndex:i] generateCode]];
        else 
            [values addObject:[PrimativeTypeUtility getDefaultValueWithNum:[parameterTypes objectAtIndex:i]]];
    }
    return values;
}
- (bool) replaceParameter:(id<CodeBlock>)oldParam newParameter:(id<CodeBlock>)newParam
{
    NSInteger index = [parameterValues indexOfObject:oldParam];
    if(index == NSNotFound)
        return false;
    
    if(oldParam.ReturnType == newParam.ReturnType)
    {
        [parameterValues replaceObjectAtIndex:index withObject:newParam];
        return true;
    }

    return false;
}

@end
