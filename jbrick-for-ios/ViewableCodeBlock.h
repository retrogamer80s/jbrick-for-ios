//
//  ViewableCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 10/3/12.
//
//

#import <Foundation/Foundation.h>
#import "CodeBlock.h"

@protocol ViewableCodeBlock <CodeBlock>
@property CGColorRef BlockColor;
@property UIImage *Icon;
-(NSString *) getDisplayName;
-(id<ViewableCodeBlock>) getPrototype;
-(NSArray *) getPropertyVariables;
- (bool) replaceParameter:(id<CodeBlock>)oldParam newParameter:(id<CodeBlock>)newParam;
@end
