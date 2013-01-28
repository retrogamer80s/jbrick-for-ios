//
//  CodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrimativeTypes.h"
#import "CodeBlockVisitor.h"

@protocol CodeBlockDelegate <NSObject>
@optional
- (void) blockWasDeleted:(NSObject *)sender;
- (void) blockChangedType:(NSObject *)sender;
- (void) blockMoved:(NSObject *)sender oldParent:(NSObject *)oldParent newParent:(NSObject *)newParent;
@end

// This class is inteded to be an abstract class... which objective-c doesn't have
// So don't use this class instead use a derived class of it.
@interface CodeBlock : NSObject <UIAlertViewDelegate>
{
    Boolean deleted;
    Primative returnType;
    CodeBlock *parent;
}
@property Primative ReturnType;
@property CodeBlock *Parent;
@property bool Deleted;
@property id<CodeBlockDelegate> Delegate;
- (NSString *) generateCode;
- (bool) addCodeBlock:(CodeBlock *)codeBlock;
- (bool) addCodeBlock:(CodeBlock *)codeBlock indexBlock:(CodeBlock *)indexBlock afterIndexBlock:(bool)afterIndexBlock;
- (void) removeCodeBlock:(CodeBlock *)codeBlock;
- (void) removeFromParent;
- (NSArray *) getAvailableParameters:(Primative)type;
- (void) addAvailableParameters:(Primative)type parameterList:(NSMutableArray *)paramList beforeIndex:(CodeBlock *)index;
- (bool) parameterIsInScope:(CodeBlock *)parameter beforeIndex:(CodeBlock *)index;
- (CodeBlock *) getParameterReferenceBlock:(Primative)type;
- (void) acceptVisitor:(id<CodeBlockVisitor>)visitor;
- (Boolean) childRequestChangeType:(CodeBlock *)child prevType:(Primative)prevType newType:(Primative)newType;
- (void) childWasDeleted:(CodeBlock *)child;

@end