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

@implementation VariableAssignmentBlock
@synthesize ReturnType;
@synthesize Parent;
@synthesize Deleted;
@synthesize BlockColor;
@synthesize Icon;

-(id) init
{
    self = [super init];
    ReturnType = VOID;
    parameters = [NSMutableArray arrayWithObject:[[ValueCodeBlock alloc] init:ANY_VARIABLE]];
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

-(bool)addCodeBlock:(id<CodeBlock>)codeBlock
{
    if(variableReference && !variableReference.Deleted && (!innerCodeBlock || innerCodeBlock.Deleted)){
        if([codeBlock isKindOfClass:[ValueCodeBlock class]]){
            codeBlock.ReturnType = variableReference.ReturnType;
        }
        if(codeBlock.ReturnType == variableReference.ReturnType){
            innerCodeBlock = codeBlock;
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}

-(bool)addCodeBlock:(id<CodeBlock>)codeBlock indexBlock:(id<CodeBlock>)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    return [self addCodeBlock:codeBlock];
}

-(UIView *) getPropertyView
{
    return [[UITextView alloc] init];
}

-(NSString *) getDisplayName
{
    return @"Variable Assignment";
}

-(id<ViewableCodeBlock>) getPrototype
{
    VariableAssignmentBlock *prototype = [[VariableAssignmentBlock alloc] init];
    prototype.BlockColor = BlockColor;
    prototype.Icon = Icon;
    return prototype;
}

-(void)removeFromParent
{
    [Parent removeCodeBlock:self];
}

-(void)removeCodeBlock:(id<CodeBlock>)codeBlock
{
    innerCodeBlock = nil;
}

-(NSArray *) getPropertyVariables
{
    return parameters;
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
    if(Parent)
        [Parent addAvailableParameters:type parameterList:paramList beforeIndex:self];
}

- (id<CodeBlock>) getParameterReferenceBlock:(Primative)type
{
    return nil; // Currently we are not supporting using non-variable blocks as parameters of other blocks
}

- (bool) replaceParameter:(id<CodeBlock>)oldParam newParameter:(id<CodeBlock>)newParam
{
    if (oldParam.ReturnType == ANY_VARIABLE){
        variableReference = newParam;
        id<CodeBlock> parameter = [[ValueCodeBlock alloc] init:ANY_VARIABLE value:[newParam generateCode]];
        [parameters replaceObjectAtIndex:0 withObject:parameter];
        return true;
    } else {
        return false;
    }

}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitVariableDeclorationBlock:self];
}
@end
