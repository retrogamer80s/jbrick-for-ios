//
//  ViewableCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 10/3/12.
//
//

#import <Foundation/Foundation.h>
#import "CodeBlock.h"

@protocol ViewableCodeBlock
@property (strong, nonatomic) UIColor *BlockColor;
@property UIImage *Icon;
@property bool ContainsChildren;
-(id<ViewableCodeBlock>) getPrototype;
-(NSArray *) getPropertyVariables;
- (bool) replaceParameter:(CodeBlock *)oldParam newParameter:(CodeBlock *)newParam;
- (NSArray *) getPropertyDisplayNames;
@end
