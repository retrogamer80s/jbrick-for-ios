//
//  VariableAssignmentBlock.m
//  jbrick-for-ios
//
//  Created by Student on 10/30/12.
//
//

#import "VariableAssignmentBlock.h"
#import "ValueCodeBlock.h"
#import "ConstantValueBlocks.h"
#import "VariableCodeBlock.h"

@implementation VariableAssignmentBlock

-(id) init
{
    self = [super init];
    self.ReturnType = VOID;
    return self;
}

-(NSString *)generateCode
{
    // The end result should look like "variable_name = value;"
    if(variableReference && innerCodeBlock && !variableReference.Deleted && !innerCodeBlock.Deleted){
        return [NSString stringWithFormat:@"%@ = %@;", [variableReference generateCode], [innerCodeBlock generateCode]];
    }
    return @"";
}

-(bool)addCodeBlock:(CodeBlock *)codeBlock
{
    if(variableReference && !variableReference.Deleted && (!innerCodeBlock || innerCodeBlock.Deleted)){
        if([codeBlock isKindOfClass:[ValueCodeBlock class]]){
            codeBlock.Parent = self;
            codeBlock.ReturnType = variableReference.ReturnType;
        }
        if(codeBlock.ReturnType == variableReference.ReturnType){
            codeBlock.Parent = self;
            innerCodeBlock = codeBlock;
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}

-(bool)addCodeBlock:(CodeBlock *)codeBlock indexBlock:(CodeBlock *)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    return [self addCodeBlock:codeBlock];
}

-(NSString *) getDisplayName
{
    return @"Variable Assignment";
}

-(ViewableCodeBlock *) getPrototype
{
    VariableAssignmentBlock *prototype = [[VariableAssignmentBlock alloc] init];
    prototype.BlockColor = self.BlockColor;
    prototype.Icon = self.Icon;
    return prototype;
}

-(void)removeCodeBlock:(CodeBlock *)codeBlock
{
    innerCodeBlock = nil;
}

-(NSArray *) getPropertyVariables
{
    if(!variableReference || variableReference.Deleted){
        parameterVariable = [[ValueCodeBlock alloc] init:ANY_VARIABLE value:@"None"];
        variableReference = nil;
    }
    return [NSArray arrayWithObject:parameterVariable];
}

- (NSArray *) getAvailableParameters:(Primative)type
{
    NSMutableArray *params = [NSMutableArray array];
    [self.Parent addAvailableParameters:type parameterList:params beforeIndex:self];
    [params addObjectsFromArray:[ConstantValueBlocks getValueConstants:type]];
    return params;
}
- (void) addAvailableParameters:(Primative)type parameterList:(NSMutableArray *)paramList beforeIndex:(CodeBlock *)index
{
    if(self.Parent)
        [self.Parent addAvailableParameters:type parameterList:paramList beforeIndex:self];
}

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{
    if (oldParam.ReturnType == ANY_VARIABLE){
        variableReference = newParam;
        newParam.Parent = self;
        CodeBlock * parameter = [[ValueCodeBlock alloc] init:ANY_VARIABLE value:[newParam generateCode]];
        parameterVariable = parameter;
        
        if([oldParam isKindOfClass:[VariableCodeBlock class]])
            [((VariableCodeBlock *)oldParam) removeParent:self];
        return true;
    } else {
        return false;
    }

}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitVariableDeclorationBlock:self];
}

- (Boolean)childRequestChangeType:(CodeBlock *)child prevType:(Primative)prevType newType:(Primative)newType
{
    if(child == innerCodeBlock)
        return false;
    
    innerCodeBlock.Deleted = true;
    return [super childRequestChangeType:child prevType:prevType newType:newType];
}
@end
