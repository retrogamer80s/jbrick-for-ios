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
#import "UIPrompt.h"

@implementation VariableDeclorationBlock
@synthesize InternalType;
@synthesize BlockColor;
@synthesize Icon;
@synthesize ContainsChildren;
@synthesize Description;

-(id) init:(NSString *)variableName type:(Primative)returnTypeParam
{
    self = [super init];
    self.Description = @"Declare a new variable, place a block inside to set the variables value";
    name = [[ValueCodeBlock alloc] init:PARAMETER_NAME value:variableName];
    type = [[ValueCodeBlock alloc] init:PARAMETER_RETURN value:@"None"];
    paramNames = [NSArray arrayWithObjects:@"Name", @"Type", nil];
    InternalType = VOID;
    varReference = [[VariableCodeBlock alloc] init:self type:InternalType];
    self.ReturnType = returnTypeParam;
    self.ContainsChildren = true;
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
            [UIPrompt prompt:message title:@"Remove References?" onResponse:^(Boolean positiveResponse) {
                if(positiveResponse) {
                    [super setDeleted:Deleted];
                    varReference.Deleted = true;
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
        if(innerCodeBlocks.count == 0)
            return [NSString stringWithFormat:@"%@ %@;", [PrimativeTypeUtility primativeToString:InternalType], self.Name];
        else
            return [NSString stringWithFormat:@"%@ %@=%@;",[PrimativeTypeUtility primativeToString:InternalType],
                                                            self.Name,
                                                            [[innerCodeBlocks objectAtIndex:0] generateCode]];
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

-(id<ViewableCodeBlock>)getPrototype {
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

- (NSArray *)getPropertyDisplayNames
{
    return paramNames;
}

- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam
{
    if (oldParam.ReturnType == PARAMETER_NAME){
        name = (ValueCodeBlock *)newParam;
        return true;
    } else if(oldParam.ReturnType == PARAMETER_RETURN && newParam.ReturnType != self.ReturnType){
        VariableCodeBlock *varRef = (VariableCodeBlock *)varReference;
        
        if(varRef.ReferenceCount + innerCodeBlocks.count > 0)
        {
            NSString *message = [NSString stringWithFormat:@"Changing the block's type will unlink %d blocks currently using it. Do you wish to continue?", varRef.ReferenceCount + innerCodeBlocks.count];
            [UIPrompt prompt:message title:@"Remove References?" onResponse:^(Boolean positiveResponse) {
                if(positiveResponse){
                    // Delete all child blocks
                    if(innerCodeBlocks.count>0){
                        [[innerCodeBlocks objectAtIndex:0] setDeleted:true];
                    }
                    
                    // Delete previous reference block so it goes back to using a default value
                    varReference.Deleted = true;
                    
                    // Create a new varReference and set it's new type
                    varReference = [[VariableCodeBlock alloc] init:self type:InternalType];
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

- (bool)canAddCodeBlock:(CodeBlock *)codeBlock{
    if(self.InternalType == VOID)
        return false;
    
    if([codeBlock isKindOfClass:[ValueCodeBlock class]])
        codeBlock.ReturnType = self.InternalType;
    return innerCodeBlocks.count < 1 && codeBlock.ReturnType == self.InternalType;
}

// Encoding/Decoding Methods
- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:type forKey:@"type"];
    [coder encodeObject:varReference forKey:@"varReference"];
    [coder encodeObject:paramNames forKey:@"paramNames"];
    [coder encodeObject:self.BlockColor forKey:@"BlockColor"];
    [coder encodeObject:self.Icon forKey:@"Icon"];
    [coder encodeBool:self.ContainsChildren forKey:@"ContainsChildren"];
    [coder encodeBool:self.InternalType forKey:@"InternalType"];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    name = [coder decodeObjectForKey:@"name"];
    type = [coder decodeObjectForKey:@"type"];
    varReference = [coder decodeObjectForKey:@"varReference"];
    paramNames = [coder decodeObjectForKey:@"paramNames"];
    self.BlockColor = [coder decodeObjectForKey:@"BlockColor"];
    self.Icon = [coder decodeObjectForKey:@"Icon"];
    self.ContainsChildren = [coder decodeBoolForKey:@"ContainsChildren"];
    self.InternalType = [coder decodeBoolForKey:@"InternalType"];
    
    return self;
}

@end
