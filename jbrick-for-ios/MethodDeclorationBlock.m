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
@synthesize Description;

static MethodDeclorationBlock *mainBlock;

-(id) init:(NSString *)methodName description:(NSString *)desc parameterTypes:(NSMutableArray *)parameters
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
    
    innerCodeBlocks = [[NSMutableArray alloc]init];
    self.ContainsChildren = YES;
    return self;
}

+(id) getMainBlock
{
    if(!mainBlock){
        mainBlock = [self createNewMainBlock];
    }
    return mainBlock;
}
+(id) createNewMainBlock
{
    MethodDeclorationBlock *newMainBlock = [[MethodDeclorationBlock alloc] init:@"main" description:@"The main block" parameterTypes:[NSArray array] parameterNames:[NSArray array] returnType:MAIN];
    UIColor *purp = [UIColor colorWithRed:162.0/255 green:92.0/255 blue:240.0/255 alpha:1];
    newMainBlock.BlockColor = purp;
    newMainBlock.Icon = [UIImage imageNamed:@"main.png"];
    newMainBlock.ContainsChildren = YES;
    return newMainBlock;
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
        [generatedCode appendString:@";"];
    }
    [generatedCode appendString:@"}"];
    
    return generatedCode;
}

-(NSString *) getDisplayName
{
    return name;
}

-(id<ViewableCodeBlock>) getPrototype
{
    MethodDeclorationBlock *prototype = [[MethodDeclorationBlock alloc] init:name description:self.Description parameterTypes:parameterTypes
                                                                  parameterNames:parameterNames returnType:self.ReturnType];
    prototype.BlockColor = self.BlockColor;
    prototype.Icon = self.Icon;
    return prototype;    
}

-(NSArray *) getPropertyVariables
{
    return parameterValues;
}

- (NSArray *)getPropertyDisplayNames
{
    return parameterNames;
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
    
    for (CodeBlock* cb in innerCodeBlocks) {
        [cb acceptVisitor:visitor];
    }
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
    [coder encodeObject:mainBlock forKey:@"mainBlock"];
    
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
    mainBlock = [coder decodeObjectForKey:@"mainBlock"];
    
    
    return self;
}


@end
