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
@synthesize BlockColor;
@synthesize Icon;
@synthesize ContainsChildren;
@synthesize Description;

-(id) init:(NSString *)methodName description:(NSString *)desc parameterTypes:(NSArray *)parameters
                       parameterNames:(NSArray *)paramNames returnType:(Primative)returnTypeParam
{
    self = [super init];
    name = methodName;
    self.ReturnType = returnTypeParam;
    self.Description = desc;
    parameterTypes = parameters;
    parameterNames = paramNames;
    parameterValues = [NSMutableArray arrayWithCapacity:[parameters count]];
    for(int i=0; i<[parameterTypes count]; i++)
        [parameterValues addObject:[[ValueCodeBlock alloc] init:[[parameters objectAtIndex:i] integerValue]]];
    
    return self;
}

-(NSString *)generateCode
{
    if(!self.Deleted){
        // The end result should look like "name(variable1, variable2)"
        NSMutableString *generatedCode = [[NSMutableString alloc] initWithString:name];
        [generatedCode appendString:@"("];
        NSArray *paramValues = [self getParameterValues];
        for(int i=0; i<[paramValues count]; i++ ){
            [generatedCode appendString:[paramValues objectAtIndex:i]];
            if (i < [paramValues count] - 1)
                [generatedCode appendString:@","];
        }
        [generatedCode appendString:@")"];
        return generatedCode;
    } else {
        return [PrimativeTypeUtility getDefaultValue:self.ReturnType];
    }
}

-(void) setVariable:(CodeBlock *)variable index:(NSInteger)index
{
    [parameterValues replaceObjectAtIndex:index withObject:variable];
}

-(NSString *)getDisplayName{
    // For simplicity just return the method name for now
    // it would be easier for the user if methods had
    // friendly names instead
    return name;
}

-(id<ViewableCodeBlock>)getPrototype{
    MethodCallCodeBlock *block = [[MethodCallCodeBlock alloc] init:name description:self.Description parameterTypes:parameterTypes parameterNames:parameterNames returnType:self.ReturnType];
    block.BlockColor = self.BlockColor;
    block.Icon = self.Icon;
    return block;
}

-(NSArray *) getPropertyVariables
{
    return parameterValues;
}

-(NSArray *)getParameterValues
{
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[parameterTypes count]];
    for (int i = 0; i<[parameterTypes count]; i++) {
        CodeBlock * variable = [parameterValues objectAtIndex:i];
        Primative primType = [[parameterTypes objectAtIndex:i] integerValue];
        // If the variable is assigned and of the right return type get it's code
        if(variable != (id)[NSNull null] && [variable ReturnType] == primType)
            [values addObject:[[parameterValues objectAtIndex:i] generateCode]];
        else 
            [values addObject:[PrimativeTypeUtility getDefaultValueWithNum:[parameterTypes objectAtIndex:i]]];
    }
    return values;
}

- (NSArray *)getPropertyDisplayNames
{
    return parameterNames;
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
    [visitor visitMethodCallCodeBlock:self];
}

// Encoding/Decoding Methods
- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:parameterValues forKey:@"parameterValues"];
    [coder encodeObject:parameterTypes forKey:@"parameterTypes"];
    [coder encodeObject:parameterNames forKey:@"parameterNames"];
    [coder encodeObject:self.BlockColor forKey:@"BlockColor"];
    [coder encodeObject:self.Icon forKey:@"Icon"];
    [coder encodeBool:self.ContainsChildren forKey:@"ContainsChildren"];

}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    name = [coder decodeObjectForKey:@"name"];
    parameterValues = [coder decodeObjectForKey:@"parameterValues"];
    parameterTypes = [coder decodeObjectForKey:@"parameterTypes"];
    parameterNames = [coder decodeObjectForKey:@"parameterNames"];
    self.BlockColor = [coder decodeObjectForKey:@"BlockColor"];
    self.Icon = [coder decodeObjectForKey:@"Icon"];
    self.ContainsChildren = [coder decodeBoolForKey:@"ContainsChildren"];

    
    return self;
}

@end
