//
//  ElseCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 4/23/13.
//
//

#import "ElseCodeBlock.h"
#import "WhileLoopCodeBlock.h"
#import "iToast.h"

@implementation ElseCodeBlock
@synthesize BlockColor;
@synthesize Icon;
@synthesize ContainsChildren;
@synthesize Description;

-(id) init
{
    self = [super init];
    name = @"Else";
    self.Description = @"Runs the blocks inside, if the previous If block didn't run. Must immediately follow an If block.";
    self.ReturnType = VOID;
    self.ContainsChildren = true;
    
    return self;
}

-(NSString *)generateCode
{
    // The end result should look like "else{method(); method(); }"
    NSMutableString *generatedCode =
    [[NSMutableString alloc] initWithString:@"else{"];
    
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
    ElseCodeBlock *prototype = [[ElseCodeBlock alloc] init];
    prototype.BlockColor = self.BlockColor;
    prototype.Icon = self.Icon;
    return prototype;
}

-(NSArray *) getPropertyVariables
{
    return [NSArray array];
}

- (NSArray *)getPropertyDisplayNames
{
    return [NSArray array];
}

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{
    return false;
}

- (bool)canAddCodeBlockAfter:(CodeBlock *)afterBlock andBefore:(CodeBlock *)beforeBlock
{
    if(afterBlock && [afterBlock isKindOfClass:[WhileLoopCodeBlock class]])
        if(((WhileLoopCodeBlock *)afterBlock).logicType == IF)
            return true;
    
    [[[[iToast makeText:@"Else blocks must be placed after If blocks"]
       setDuration:iToastDurationNormal] setGravity:iToastGravityTop ] show];
    return false;
}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitElseCodeBlock:self];
    
    for (CodeBlock* cb in innerCodeBlocks) {
        [cb acceptVisitor:visitor];
    }
}

// Encoding/Decoding Methods
- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:self.BlockColor forKey:@"BlockColor"];
    [coder encodeObject:self.Icon forKey:@"Icon"];
    [coder encodeBool:self.ContainsChildren forKey:@"ContainsChildren"];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    name = [coder decodeObjectForKey:@"name"];
    self.BlockColor = [coder decodeObjectForKey:@"BlockColor"];
    self.Icon = [coder decodeObjectForKey:@"Icon"];
    self.ContainsChildren = [coder decodeBoolForKey:@"ContainsChildren"];
    
    return self;
}

@end

