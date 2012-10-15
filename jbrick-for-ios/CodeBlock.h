//
//  CodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrimativeTypes.h"

@protocol CodeBlock
@property Primative ReturnType;
@property id<CodeBlock> Parent;
@property bool Deleted;
- (NSString *) generateCode;
- (bool) addCodeBlock:(id<CodeBlock>)codeBlock;
- (bool) addCodeBlock:(id<CodeBlock>)codeBlock indexBlock:(id<CodeBlock>)indexBlock afterIndexBlock:(bool)afterIndexBlock;
- (void) removeCodeBlock:(id<CodeBlock>)codeBlock;
- (void) removeFromParent;
@end
