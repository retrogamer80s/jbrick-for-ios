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
@synthesize BlockColor;
@synthesize Icon;
@synthesize ContainsChildren;

-(id) init
{
    self = [super init];
    self.ReturnType = VOID;
    self.ContainsChildren = YES;
    paramNames = [NSArray arrayWithObjects:@"Variable", nil];
    return self;
}

-(NSString *)generateCode
{
    // The end result should look like "variable_name = value;"
    if(variableReference && innerCodeBlock && !variableReference.Deleted && !innerCodeBlock.Deleted){
        return [NSString stringWithFormat:@"%@ = %@;", [variableReference generateCode], [innerCodeBlock generateCode]];
    } else if(variableReference && !innerCodeBlock && !variableReference.Deleted){
        return [NSString stringWithFormat:@"%@ = %@;", [variableReference generateCode], [PrimativeTypeUtility getDefaultValue:variableReference.ReturnType]];
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

-(id<ViewableCodeBlock>) getPrototype
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
    } else {
        parameterVariable = [[ValueCodeBlock alloc] init:ANY_VARIABLE value:[variableReference generateCode]];
    }
    return [NSArray arrayWithObject:parameterVariable];
}

- (NSArray *)getPropertyDisplayNames
{
    return paramNames;
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
    } else {
        return false;
    }

}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitVariableDeclorationBlock:self];
    
    [innerCodeBlock acceptVisitor:visitor];
}

- (Boolean)childRequestChangeType:(CodeBlock *)child prevType:(Primative)prevType newType:(Primative)newType
{
    if(child == innerCodeBlock)
        return false;
    
    innerCodeBlock.Deleted = true;
    return [super childRequestChangeType:child prevType:prevType newType:newType];
}

// Encoding/Decoding Methods
- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:variableReference forKey:@"variableReference"];
    [coder encodeObject:parameterVariable forKey:@"parameterVariable"];
    [coder encodeObject:innerCodeBlock forKey:@"innerCodeBlock"];
    [coder encodeObject:paramNames forKey:@"paramNames"];
    [coder encodeObject:self.BlockColor forKey:@"BlockColor"];
    [coder encodeObject:self.Icon forKey:@"Icon"];
    [coder encodeBool:self.ContainsChildren forKey:@"ContainsChildren"];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    variableReference = [coder decodeObjectForKey:@"variableReference"];
    parameterVariable = [coder decodeObjectForKey:@"parameterVariable"];
    innerCodeBlock = [coder decodeObjectForKey:@"innerCodeBlock"];
    paramNames = [coder decodeObjectForKey:@"paramNames"];
    self.BlockColor = [coder decodeObjectForKey:@"BlockColor"];
    self.Icon = [coder decodeObjectForKey:@"Icon"];
    self.ContainsChildren = [coder decodeBoolForKey:@"ContainsChildren"];
    
    return self;
}

@end
