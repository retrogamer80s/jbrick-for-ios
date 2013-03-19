//
//  CodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 11/5/12.
//
//

#import "CodeBlock.h"
#import "ConstantValueBlocks.h"
#import "PrimativeTypeUtility.h"

@implementation CodeBlock
@synthesize Delegate;

- (CodeBlock *)Parent { return parent; }
- (void)setParent:(CodeBlock *)Parent {
    parent = Parent;
    if(Delegate && [Delegate respondsToSelector:@selector(blockMoved:oldParent:newParent:)])
        [Delegate blockMoved:self oldParent:parent newParent:Parent];
}

- (Primative)ReturnType { return returnType; }
- (void)setReturnType:(Primative)ReturnType {
    Boolean canChange = true;
    if(parent)
        canChange = [parent childRequestChangeType:self prevType:returnType newType:ReturnType];
    
    if(canChange)
        returnType = ReturnType;
    
    if(Delegate && [Delegate respondsToSelector:@selector(blockChangedType:)])
        [Delegate blockChangedType:self];
}

- (bool)Deleted { return deleted; }
- (void)setDeleted:(bool)Deleted {
    if(deleted != Deleted){
        deleted = Deleted;
        if(parent)
            [parent childWasDeleted:self];
        if(Delegate && [Delegate respondsToSelector:@selector(blockWasDeleted:)] && !parent.Deleted)
            [Delegate blockWasDeleted:self];
    }
}

- (NSString *) getDisplayName
{
    return [PrimativeTypeUtility primativeToName:returnType];
}

- (NSString *) generateCode
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (bool) addCodeBlock:(CodeBlock *)codeBlock
{
    return false; // By default codeBlocks do not have children
}

- (bool) addCodeBlock:(CodeBlock *)codeBlock indexBlock:(CodeBlock *)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    return false; // By default codeBlocks do not have children
}

- (void) removeCodeBlock:(CodeBlock *)codeBlock
{
    // By default codeBlocks don't have children
}

- (void) removeFromParent
{
    if(parent)
        [parent removeCodeBlock:self];
}

- (NSArray *) getAvailableParameters:(Primative)type
{
    NSMutableArray *params = [NSMutableArray array];
    if(parent)
        [parent addAvailableParameters:type parameterList:params beforeIndex:self];
    [params addObjectsFromArray:[ConstantValueBlocks getValueConstants:type]];
    return params;
}

- (bool) parameterIsInScope:(CodeBlock *)parameter beforeIndex:(CodeBlock *)index
{
    if(parent)
        return [parent parameterIsInScope:parameter beforeIndex:self];
    else
        return false;
}

- (void) addAvailableParameters:(Primative)type parameterList:(NSMutableArray *)paramList beforeIndex:(CodeBlock *)index
{
    // This method is called from child blocks, by default a codeBlock doesn't have children
}

- (CodeBlock *) getParameterReferenceBlock:(Primative)type
{
    return nil; // Only VariableBlocks can construct a reference block;
}

- (void) acceptVisitor:(id<CodeBlockVisitor>)visitor
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (Boolean) childRequestChangeType:(CodeBlock *)child prevType:(Primative)prevType newType:(Primative)newType
{
    return true; // Children are allowed to change type unless this method is overwritten
}

- (void) childWasDeleted:(CodeBlock *)child
{
    // Optionally overwrite this method to be notified when a child block is deleted
}


// Encoding/Decoding Methods
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeBool:deleted forKey:@"deleted"];
    [coder encodeInt32:returnType forKey:@"returnType"];
    [coder encodeObject:parent forKey:@"parent"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    deleted = [decoder decodeBoolForKey:@"deleted"];
    returnType = [decoder decodeInt32ForKey:@"returnType"];
    parent = [decoder decodeObjectForKey:@"parent"];
    
    return self;
}

@end
