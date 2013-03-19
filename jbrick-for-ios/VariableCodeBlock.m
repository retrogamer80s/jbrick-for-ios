//
//  VariableCodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VariableCodeBlock.h"
#import "ConstantValueBlocks.h"

@implementation VariableCodeBlock

-(id) init:(VariableDeclorationBlock *)variableParam type:(Primative)primitive
{
    self = [super init];
    variable = variableParam;
    variable.Delegate = self;
    self.ReturnType = primitive;
    parents = [NSMutableArray array];
    return self;
}

-(CodeBlock *)Parent{
    if(parents.count > 0)
        return [parents objectAtIndex:0];
    else
        return nil;
}
-(void)setParent:(CodeBlock *)Parent
{
    [parents addObject:Parent];
    //Parent.Delegate = self; // Cannot reasign the delegate because UIBlock uses the delegate methods
}
-(void) removeParent:(CodeBlock *)oldParent
{
    [parents removeObject:oldParent];
    oldParent.Delegate = NULL;
}

- (void)setReturnType:(Primative)ReturnType
{
    super.ReturnType = ReturnType;
    for(CodeBlock *referenced in parents)
        [referenced childRequestChangeType:self prevType:returnType newType:ReturnType];
}

-(bool)Deleted {
    return deleted || variable.Deleted;
}

-(NSInteger)ReferenceCount {
    
    for(CodeBlock * parentBlock in [parents copy])
        if(parentBlock.Deleted)
            [parents removeObject:parentBlock];
    
    return parents.count;
}

- (NSString *) generateCode
{
    if(!self.Deleted && variable && !variable.Deleted && variable.InternalType == self.ReturnType)
        return variable.Name;
    else 
        return [PrimativeTypeUtility getDefaultValue:self.ReturnType];
}

-(void)acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [visitor visitVariableCodeBlock:self];
}
/* This method cannot be used because only UIBlock should be a delegate of codeblocks
 
-(void) blockMoved:(NSObject *)sender oldParent:(NSObject *)oldParent newParent:(NSObject *)newParent
{
    int outOfScopeCount = 0;

    for (CodeBlock * reference in parents) {
        if(! [reference parameterIsInScope:variable beforeIndex:self])
            outOfScopeCount++;
    }
    
    Boolean response = [UIPrompt promptBlocking:@"Parameters out of scope" title:@"Variable out of scope"];
    
    NSLog([NSString stringWithFormat:@"%d are now out of scope, %d", outOfScopeCount, response]);
}
 */

// Encoding/Decoding Methods
- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:variable forKey:@"variable"];
    [coder encodeObject:parents forKey:@"parents"];
    [coder encodeBool:promptDone forKey:@"promptDone"];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    variable = [coder decodeObjectForKey:@"variable"];
    parents = [coder decodeObjectForKey:@"parents"];
    promptDone = [coder decodeBoolForKey:@"promptDone"];
    
    return self;
}

@end
