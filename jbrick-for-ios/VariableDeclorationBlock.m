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
@synthesize ReturnType;
@synthesize Parent;
@synthesize Deleted;
@synthesize BlockColor;
@synthesize Icon;

-(id) init:(NSString *)variableName type:(Primative)returnType
{
    self = [super init];
    name = [[ValueCodeBlock alloc] init:PARAMETER_NAME value:variableName];
    type = [[ValueCodeBlock alloc] init:PARAMETER_RETURN value:[PrimativeTypeUtility primativeToName:returnType]];
    varReference = [[VariableCodeBlock alloc] init:self type:ReturnType];
    ReturnType = returnType;
    return self;
}

-(NSString *)Name
{
    return name.generateCode;
}

-(NSString *)generateCode
{
    if(!Deleted){
        return [NSString stringWithFormat:(@"%@ %@;", [PrimativeTypeUtility primativeToString:ReturnType], self.Name)];
    } else {
        return nil;
    }
}

-(UIView *) getPropertyView
{
    return nil;
}

-(NSString *)getDisplayName{
    // For simplicity just return the method name for now
    // it would be easier for the user if methods had
    // friendly names instead
    return self.Name;
}

-(id<ViewableCodeBlock>)getPrototype{
    VariableDeclorationBlock *block = [[VariableDeclorationBlock alloc] init:self.Name type:ReturnType];
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
    return [NSArray arrayWithObjects:name, type, nil];
}

- (NSArray *) getAvailableParameters:(Primative)typeParam
{
    NSMutableArray *params = [NSMutableArray array];
    [Parent addAvailableParameters:typeParam parameterList:params beforeIndex:self];
    [params addObjectsFromArray:[ConstantValueBlocks getValueConstants:typeParam]];
    return params;
}
- (void) addAvailableParameters:(Primative)type parameterList:(NSMutableArray *)paramList beforeIndex:(id<CodeBlock>)index
{
    // This method should only be called from child blocks, and this type of block has no children
}

- (id<CodeBlock>) getParameterReferenceBlock:(Primative)typeParam
{
    if(ReturnType == typeParam)
        return varReference;
    else
        return nil;
        
}

- (bool) replaceParameter:(id<CodeBlock>)oldParam newParameter:(id<CodeBlock>)newParam
{
    if (oldParam.ReturnType == PARAMETER_NAME){
        name = (ValueCodeBlock *)newParam;
        return true;
    } else if(oldParam.ReturnType == PARAMETER_RETURN && newParam.ReturnType != ReturnType){
        ReturnType = newParam.ReturnType;
        type = [[ValueCodeBlock alloc] init:PARAMETER_RETURN value:[PrimativeTypeUtility primativeToName:ReturnType]];
        varReference.Deleted = true;
        varReference = [[VariableCodeBlock alloc] init:self type:ReturnType];
        
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
