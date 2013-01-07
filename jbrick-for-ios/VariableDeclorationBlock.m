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
@synthesize InternalType;

-(id) init:(NSString *)variableName type:(Primative)returnTypeParam
{
    self = [super init];
    name = [[ValueCodeBlock alloc] init:PARAMETER_NAME value:variableName];
    type = [[ValueCodeBlock alloc] init:PARAMETER_RETURN value:@"None"];
    InternalType = VOID;
    varReference = [[VariableCodeBlock alloc] init:self type:InternalType];
    self.ReturnType = returnTypeParam;
    return self;
}

-(NSString *)Name
{
    return name.generateCode;
}

-(void)setDeleted:(bool)Deleted
{
    if(!deleted){
        VariableCodeBlock *varRef = (VariableCodeBlock *)varReference;
        
        if(varRef.ReferenceCount > 0)
        {
            NSString *message = [NSString stringWithFormat:@"Deleting the block will unlink %d blocks currently using it. Do you wish to continue?", varRef.ReferenceCount];
            [self requestUserResponse:message title:@"Remove References?" onResponse:^(Boolean positiveResponse) {
                if(positiveResponse) {
                    [super setDeleted:Deleted];
                    varReference.Deleted = true;
                    varReference.ReturnType = VOID;
                }
            }];
        }
        else
            [super setDeleted:Deleted];
    }
}

-(NSString *)generateCode
{
    if(!self.Deleted){
        return [NSString stringWithFormat:(@"%@ %@;", [PrimativeTypeUtility primativeToString:self.ReturnType], self.Name)];
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

-(ViewableCodeBlock *)getPrototype {
    VariableDeclorationBlock *block = [[VariableDeclorationBlock alloc] init:self.Name type:self.ReturnType];
    block.BlockColor = self.BlockColor;
    block.Icon = self.Icon;
    return block;
}

- (CodeBlock *) getParameterReferenceBlock:(Primative)typeParam
{
    if(InternalType == typeParam || (typeParam == ANY_VARIABLE && InternalType != VOID))
        return varReference;
    else
        return nil;
        
}

-(NSArray *) getPropertyVariables
{
    return [NSArray arrayWithObjects:name, type, nil];
}

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{
    if (oldParam.ReturnType == PARAMETER_NAME){
        name = (ValueCodeBlock *)newParam;
        return true;
    } else if(oldParam.ReturnType == PARAMETER_RETURN && newParam.ReturnType != self.ReturnType){
        VariableCodeBlock *varRef = (VariableCodeBlock *)varReference;
        
        if(varRef.ReferenceCount > 0)
        {
            NSString *message = [NSString stringWithFormat:@"Changing the block's type will unlink %d blocks currently using it. Do you wish to continue?", varRef.ReferenceCount];
            [self requestUserResponse:message title:@"Remove References?" onResponse:^(Boolean positiveResponse) {
                if(positiveResponse){
                    [self setInnerType:newParam.ReturnType];
                }
            }];
        } else {
            [self setInnerType:newParam.ReturnType];
        }
        return true;
    } else {
        return false;
    }
}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitVariableDeclorationBlock:self];
}

-(void)setInnerType:(Primative)newType
{
    InternalType = newType;
    type = [[ValueCodeBlock alloc] init:PARAMETER_RETURN value:[PrimativeTypeUtility primativeToName:newType]];
    varReference.Deleted = true;
    varReference.ReturnType = newType;
    varReference = [[VariableCodeBlock alloc] init:self type:newType];

}

@end
