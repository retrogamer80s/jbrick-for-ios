//
//  ViewableCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 10/3/12.
//
//

#import <Foundation/Foundation.h>
#import "CodeBlock.h"

@interface ViewableCodeBlock : CodeBlock
@property CGColorRef BlockColor;
@property UIImage *Icon;
@property bool ContainsChildren;
-(NSString *) getDisplayName;
-(ViewableCodeBlock *) getPrototype;
-(NSArray *) getPropertyVariables;
- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam;
@end
