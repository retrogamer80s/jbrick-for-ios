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
@synthesize Description;

-(id) init:(LogicType)ifOrWhile
{
    self = [super init];
    type = ifOrWhile;
    if(ifOrWhile == WHILE){
        name = @"While";
        src = @"while";
        self.Description = @"Runs the blocks inside repeatedly as long as the Run If property is true";
    } else {
        name = @"If";
        src = @"if";
        self.Description = @"Runs the blocks inside only if the Run If property is true";
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
    
    for (CodeBlock* cb in innerCodeBlocks) {
        [cb acceptVisitor:visitor];
    }
}

// Encoding/Decoding Methods
- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:src forKey:@"src"];
    [coder encodeInt32:type forKey:@"type"];
    [coder encodeObject:parameter forKey:@"parameter"];
    [coder encodeObject:paramNames forKey:@"paramNames"];
    [coder encodeObject:self.BlockColor forKey:@"BlockColor"];
    [coder encodeObject:self.Icon forKey:@"Icon"];
    [coder encodeBool:self.ContainsChildren forKey:@"ContainsChildren"];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    name = [coder decodeObjectForKey:@"name"];
    src = [coder decodeObjectForKey:@"src"];
    type = [coder decodeInt32ForKey:@"type"];
    parameter = [coder decodeObjectForKey:@"parameter"];
    paramNames = [coder decodeObjectForKey:@"paramNames"];
    self.BlockColor = [coder decodeObjectForKey:@"BlockColor"];
    self.Icon = [coder decodeObjectForKey:@"Icon"];
    self.ContainsChildren = [coder decodeBoolForKey:@"ContainsChildren"];
    
    return self;
}

@end
