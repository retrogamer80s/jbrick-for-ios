//
//  VariableMathBlock.m
//  jbrick-for-ios
//
//  Created by Student on 11/6/12.
//
//

#import "VariableMathBlock.h"
#import "ValueCodeBlock.h"
#import "VariableCodeBlock.h"

@implementation VariableMathBlock
@synthesize BlockColor;
@synthesize Icon;
@synthesize ContainsChildren;

-(id) init
{
    self = [super init];
    self.ReturnType = VOID;
    innerCodeBlocks = [NSMutableArray array];
    mathOpBlock = [[ValueCodeBlock alloc] init:MATH_OPERATION value:@"+"];
    self.ContainsChildren = YES;
    return self;
}

-(NSString *)generateCode
{
    // The end result should look like "variable_name = value + value + value;"
    
    if(variableReference && innerCodeBlocks.count > 0 && !variableReference.Deleted){
        NSMutableString *mathOps = [NSMutableString string];
        for(int i=0; i<innerCodeBlocks.count; i++){
            [mathOps stringByAppendingString:[innerCodeBlocks[i] generateCode]];
            if(i != innerCodeBlocks.count -1)
                [mathOps stringByAppendingString:[mathOpBlock generateCode]];
        }
        
        return [NSString stringWithFormat:@"%@ = %@;", [variableReference generateCode], mathOps];
    }
    return @"";
}

-(bool)addCodeBlock:(CodeBlock *)codeBlock
{
    if(variableReference && !variableReference.Deleted && innerCodeBlocks){
        return [self insertCodeBlockAtIndex:innerCodeBlocks.count codeBlock:codeBlock];
    } else {
        return false;
    }
}

-(bool)addCodeBlock:(CodeBlock *)codeBlock indexBlock:(CodeBlock *)indexBlock afterIndexBlock:(bool)afterIndexBlock
{   
    if(variableReference && !variableReference.Deleted && innerCodeBlocks){
        NSInteger insertIndex = 0;
        if(insertIndex == NSNotFound)
            return false;
        
        if(afterIndexBlock)
            return [self insertCodeBlockAtIndex:insertIndex+1 codeBlock:codeBlock];
        else
            return [self insertCodeBlockAtIndex:insertIndex codeBlock:codeBlock];
    } else {
        return false;
    }
}

-(bool)insertCodeBlockAtIndex:(NSInteger)index codeBlock:(CodeBlock *)codeBlock{
    
    if([codeBlock isKindOfClass:[ValueCodeBlock class]])
        codeBlock.ReturnType = variableReference.ReturnType;
    
    if(codeBlock.ReturnType == variableReference.ReturnType){
        codeBlock.Parent = self;
        [innerCodeBlocks insertObject:codeBlock atIndex:index];
        return true;
    }
    
    return false;
}

-(NSString *) getDisplayName
{
    return @"Variable Math";
}

-(id<ViewableCodeBlock>) getPrototype
{
    VariableMathBlock *prototype = [[VariableMathBlock alloc] init];
    prototype.BlockColor = self.BlockColor;
    prototype.Icon = self.Icon;
    return prototype;
}

-(void)removeCodeBlock:(CodeBlock *)codeBlock
{
    [innerCodeBlocks removeObject:codeBlock];
}

-(NSArray *) getPropertyVariables
{
    if(!variableReference || variableReference.Deleted){
        parameterVariable = [[ValueCodeBlock alloc] init:ANY_VARIABLE value:@"None"];
        variableReference = nil;
    } else {
        parameterVariable = [[ValueCodeBlock alloc] init:ANY_VARIABLE value:[variableReference generateCode]];
    }
    return [NSArray arrayWithObjects:parameterVariable, mathOpBlock, nil];
}

- (void) addAvailableParameters:(Primative)type parameterList:(NSMutableArray *)paramList beforeIndex:(CodeBlock *)index
{
    if(self.Parent)
        [self.Parent addAvailableParameters:type parameterList:paramList beforeIndex:self];
}

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{
    if (oldParam.ReturnType == ANY_VARIABLE){
        [variableReference removeParent:self];
        variableReference = (VariableCodeBlock *)newParam;
        newParam.Parent = self;
        CodeBlock * parameter = [[ValueCodeBlock alloc] init:ANY_VARIABLE value:[newParam generateCode]];
        parameterVariable = parameter;
        
        if([oldParam isKindOfClass:[VariableCodeBlock class]])
            [((VariableCodeBlock *)oldParam) removeParent:self];
        return true;
    } else if (oldParam.ReturnType == MATH_OPERATION && newParam.ReturnType == MATH_OPERATION) {
        mathOpBlock = newParam;
        return true;
    } else {
        return false;
    }
    
}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitVariableMathBlock:self];
}

- (Boolean)childRequestChangeType:(CodeBlock *)child prevType:(Primative)prevType newType:(Primative)newType
{
    if([innerCodeBlocks containsObject:child])
        return false;
    
    for(CodeBlock *child in [innerCodeBlocks copy])
        child.Deleted = true;
    
    innerCodeBlocks = [NSMutableArray array];
    return [super childRequestChangeType:child prevType:prevType newType:newType];
}

// ******** Private Methods ********

@end
