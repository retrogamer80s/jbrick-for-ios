//
//  CodeBlock.m
//  jbrick-for-ios
//
//  Created by Student on 11/5/12.
//
//

#import "CodeBlock.h"
#import "ConstantValueBlocks.h"

@implementation CodeBlock
@synthesize Parent;
@synthesize Delegate;

- (Primative)ReturnType { return returnType; }
- (void)setReturnType:(Primative)ReturnType {
    Boolean canChange = true;
    if(Parent)
        canChange = [Parent childRequestChangeType:self prevType:returnType newType:ReturnType];
    
    if(canChange)
        returnType = ReturnType;
    
    if(Delegate && [Delegate respondsToSelector:@selector(blockChangedType:)])
        [Delegate blockChangedType:self];
}

- (bool)Deleted { return deleted; }
- (void)setDeleted:(bool)Deleted {
    if(deleted != Deleted){
        deleted = Deleted;
        if(Parent)
            [Parent childWasDeleted:self];
        if(Delegate && [Delegate respondsToSelector:@selector(blockWasDeleted:)] && !Parent.Deleted)
            [Delegate blockWasDeleted:self];
    }
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
    if(Parent)
        [Parent removeCodeBlock:self];
}

- (NSArray *) getAvailableParameters:(Primative)type
{
    NSMutableArray *params = [NSMutableArray array];
    if(Parent)
        [Parent addAvailableParameters:type parameterList:params beforeIndex:self];
    [params addObjectsFromArray:[ConstantValueBlocks getValueConstants:type]];
    return params;
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

- (void)requestUserResponse:(NSString *)message title:(NSString *)title onResponse:(onResponseType)onRespondedBlock
{
    onResponse = onRespondedBlock;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"YES"
                                              otherButtonTitles:@"NO", nil];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if(onResponse)
                onResponse(true);
            break;
        case 1:
            if(onResponse)
                onResponse(false);
            break;
        default:
            break;
    }
    onResponse = nil;
}
@end