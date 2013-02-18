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

@implementation LogicalOperatorCodeBlock
@synthesize BlockColor;
@synthesize Icon;
@synthesize ContainsChildren;

-(id) init
{
    self = [super init];
    name = @"Logical Operation";
    operation = [[ValueCodeBlock alloc] init:LOGIC_OPERATION value:@"=="];
    self.ReturnType = BOOLEAN;
    self.ContainsChildren = true;
    
    return self;
}

-(NSString *)generateCode
{
    // The end result should look like "(variable operator variable)" or "!variable"
    if([operation generateCode] == @"!"){
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

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{
    if(oldParam.ReturnType == newParam.ReturnType)
    {
        operation = newParam;
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

- (bool)addCodeBlock:(CodeBlock *)codeBlock
{
    if([codeBlock isKindOfClass:[ValueCodeBlock class]]){
        codeBlock.ReturnType = BOOLEAN;
    }
    
    if(codeBlock.ReturnType == BOOLEAN){
        if([operation generateCode] != @"!" || innerCodeBlocks.count == 0){
            [super addCodeBlock:codeBlock];
        } else {
            
        }
    } else {
        return false;
    }
}
- (bool)addCodeBlock:(CodeBlock *)codeBlock indexBlock:(CodeBlock *)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    if([codeBlock isKindOfClass:[ValueCodeBlock class]]){
        codeBlock.ReturnType = BOOLEAN;
    }
    
    if(codeBlock.ReturnType == BOOLEAN){
        if([operation generateCode] != @"!" || innerCodeBlocks.count == 0){
            [super addCodeBlock:codeBlock indexBlock:indexBlock afterIndexBlock:afterIndexBlock];
        } else {
            
        }
    } else {
        return false;
    }
}

@end
