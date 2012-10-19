//
//  VariableDeclorationBlock.m
//  jbrick-for-ios
//
//  Created by Student on 10/17/12.
//
//

#import "VariableDeclorationBlock.h"
#import "PrimativeTypeUtility.h"
#import "VariableCodeBlock.h"
#import "ConstantValueBlocks.h"

@implementation VariableDeclorationBlock
@synthesize Name;
@synthesize ReturnType;
@synthesize Parent;
@synthesize Deleted;
@synthesize BlockColor;
@synthesize Icon;

-(id) init:(NSString *)variableName type:(Primative)returnType
{
    self = [super init];
    Name = variableName;
    ReturnType = returnType;
    return self;
}

-(NSString *)generateCode
{
    if(!Deleted){
        return [NSString stringWithFormat:(@"%@ %@;", [PrimativeTypeUtility primativeToString:ReturnType], Name)];
    } else {
        return nil;
    }
}

-(UIView *) getPropertyView
{
    return [PrimativeTypeUtility constructDefaultView:ReturnType];
}

-(NSString *)getDisplayName{
    // For simplicity just return the method name for now
    // it would be easier for the user if methods had
    // friendly names instead
    return Name;
}

-(id<ViewableCodeBlock>)getPrototype{
    VariableDeclorationBlock *block = [[VariableDeclorationBlock alloc] init:Name type:ReturnType];
    block.BlockColor = BlockColor;
    block.Icon = Icon;
    return block;
}

-(bool)addCodeBlock:(id<CodeBlock>)codeBlock
{
    return false; // Cannot add blocks to a variable block
}

-(bool)addCodeBlock:(id<CodeBlock>)codeBlock indexBlock:(id<CodeBlock>)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    return false; // Cannot add blocks to a variable block
}

-(void)removeFromParent
{
    [Parent removeCodeBlock:self];
}

-(void)removeCodeBlock:(id<CodeBlock>)codeBlock
{
    // variable decloration blocks don't have children and thus can't remove them
}
-(NSArray *) getPropertyVariables
{
    return [NSArray arrayWithObject:[[ValueCodeBlock alloc] init:ReturnType]];
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
    // This method should only be called from child blocks, and this type of block has no children
}

- (id<CodeBlock>) getParameterReferenceBlock:(Primative)type
{
    if(ReturnType == type)
        return [[VariableCodeBlock alloc] init:self type:type];
    else
        return nil;
        
}

- (bool) replaceParameter:(id<CodeBlock>)oldParam newParameter:(id<CodeBlock>)newParam
{
    return false; //this method doesn't apply to a variable def since it has no parameters
}

@end
