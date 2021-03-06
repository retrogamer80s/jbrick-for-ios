//
//  LogicalOperatorCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 2/18/13.
//
//

#import "LogicalOperatorCodeBlock.h"
#import "ValueCodeBlock.h"
#import "VariableCodeBlock.h"
#import "iToast.h"

@implementation LogicalOperatorCodeBlock
@synthesize BlockColor;
@synthesize Icon;
@synthesize ContainsChildren;
@synthesize Description;

-(id) init
{
    self = [super init];
    name = @"Logical Operation";
    operation = [[ValueCodeBlock alloc] init:LOGIC_OPERATION value:@"&&"];
    paramNames = [NSArray arrayWithObject:@"Logic Operation"];
    self.Description = @"Performs the specified Logic Operation on the blocks inside and returns the result";
    self.ReturnType = BOOLEAN;
    self.ContainsChildren = true;
    
    return self;
}

-(NSString *)generateCode
{
    // The end result should look like "(variable operator variable)" or "!variable"
    if([[operation generateCode] isEqual: @"!"]){
        if(innerCodeBlocks.count == 1){
            return [NSString stringWithFormat:@"!%@", [[innerCodeBlocks objectAtIndex:0] generateCode]];
        }
    }
    NSMutableString *generatedCode =
    [[NSMutableString alloc] initWithString:@"("];
    
    for(int i=0; i<innerCodeBlocks.count; i++){
        [generatedCode appendString:[[innerCodeBlocks objectAtIndex:i] generateCode]];
        if(i < innerCodeBlocks.count - 1){
            [generatedCode appendString:[NSString stringWithFormat:@" %@ ", [operation generateCode]]];
        }
    }
    [generatedCode appendString:@")"];
    
    return generatedCode;
}

-(NSString *) getDisplayName
{
    return name;
}

-(id<ViewableCodeBlock>) getPrototype
{
    LogicalOperatorCodeBlock *prototype = [[LogicalOperatorCodeBlock alloc] init];
    prototype.BlockColor = self.BlockColor;
    prototype.Icon = self.Icon;
    return prototype;
}

-(NSArray *) getPropertyVariables
{
    return [NSArray arrayWithObject:operation];
}

- (NSArray *)getPropertyDisplayNames
{
    return paramNames;
}

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{
    if(oldParam.ReturnType == newParam.ReturnType)
    {
        if([[newParam generateCode] isEqual: @"!"] && innerCodeBlocks.count > 1)
        {
            NSString *message = @"Changing the operation to ! will remove all but the first child block, do you wish to continue?";
            [UIPrompt prompt:message title:@"Delete Child Blocks?" onResponse:^(Boolean positiveResponse) {
                if(positiveResponse){
                    operation = newParam;
                    
                    if([oldParam isKindOfClass:[VariableCodeBlock class]])
                        [((VariableCodeBlock *)oldParam) removeParent:self];
                    newParam.Parent = self;
                    
                    while (innerCodeBlocks.count > 1) {
                        
                        // As blocks are deleted they are automatically removed from the list, so
                        // this will get rid of all but the first block
                        ((CodeBlock*)[innerCodeBlocks objectAtIndex:1]).Deleted = true;
                    }
                }
            }];
        } else {
             operation = newParam;
            
             if([oldParam isKindOfClass:[VariableCodeBlock class]])
                 [((VariableCodeBlock *)oldParam) removeParent:self];
             newParam.Parent = self;
        }
        return true;
    }
    
    return false;
}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitLogicalOperatorCodeBlock:self];
    
    for (CodeBlock* cb in innerCodeBlocks) {
        [cb acceptVisitor:visitor];
    }
}

- (bool)canAddCodeBlock:(CodeBlock *)codeBlock
{
    if([codeBlock isKindOfClass:[ValueCodeBlock class]]){
        codeBlock.ReturnType = BOOLEAN;
    }
    
    if(codeBlock.ReturnType == BOOLEAN)
    {
        if([[operation generateCode] isEqual: @"!"] && innerCodeBlocks.count >= 1)
        {
            // Negation can only be applied to one child block
            [[[[iToast makeText:@"Only one block can be modified when using the ! operator"]
               setDuration:iToastDurationNormal] setGravity:iToastGravityTop ] show];
            return false;
        }
        else
        {
            return [super canAddCodeBlock:codeBlock];
        }
    }
    else
    {
        return false;
    }
}

// Encoding/Decoding Methods
- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:operation forKey:@"operation"];
    [coder encodeObject:paramNames forKey:@"paramNames"];
    [coder encodeObject:self.BlockColor forKey:@"BlockColor"];
    [coder encodeObject:self.Icon forKey:@"Icon"];
    [coder encodeBool:self.ContainsChildren forKey:@"ContainsChildren"];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    name = [coder decodeObjectForKey:@"name"];
    operation = [coder decodeObjectForKey:@"operation"];
    paramNames = [coder decodeObjectForKey:@"paramNames"];
    self.BlockColor = [coder decodeObjectForKey:@"BlockColor"];
    self.Icon = [coder decodeObjectForKey:@"Icon"];
    self.ContainsChildren = [coder decodeBoolForKey:@"ContainsChildren"];
    
    return self;
}

@end
