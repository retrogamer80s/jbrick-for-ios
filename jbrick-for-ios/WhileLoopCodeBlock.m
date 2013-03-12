//
//  WhileLoopCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 2/18/13.
//
//

#import "WhileLoopCodeBlock.h"
#import "ValueCodeBlock.h"
#import "VariableCodeBlock.h"

@implementation WhileLoopCodeBlock
@synthesize BlockColor;
@synthesize Icon;
@synthesize ContainsChildren;

-(id) init:(LogicType)ifOrWhile
{
    self = [super init];
    type = ifOrWhile;
    if(ifOrWhile == WHILE){
        name = @"While";
        src = @"while";
    } else {
        name = @"If";
        src = @"if";
    }
    parameter = [[ValueCodeBlock alloc] init:BOOLEAN];
    paramNames = [NSArray arrayWithObject: @"Run If"];
    self.ReturnType = VOID;
    self.ContainsChildren = true;
    
    return self;
}

-(NSString *)generateCode
{
    // The end result should look like "while(variable){ method(); method(); }"
    NSMutableString *generatedCode =
        [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@(%@){", src, [parameter generateCode]]];
    
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
    WhileLoopCodeBlock *prototype = [[WhileLoopCodeBlock alloc] init:type];
    prototype.BlockColor = self.BlockColor;
    prototype.Icon = self.Icon;
    return prototype;
}

-(NSArray *) getPropertyVariables
{
    return [NSArray arrayWithObject:parameter];
}

- (NSArray *)getPropertyDisplayNames
{
    return paramNames;
}

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{   
    if(oldParam.ReturnType == newParam.ReturnType)
    {
        parameter = newParam;
        if([oldParam isKindOfClass:[VariableCodeBlock class]])
            [((VariableCodeBlock *)oldParam) removeParent:self];
        newParam.Parent = self;
        return true;
    }
    
    return false;
}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitWhileLoopCodeBlock:self];
}

@end
