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
-(UIView *) getPropertyView;
-(NSString *) getDisplayName;
-(id<ViewableCodeBlock>) getPrototype;
@end
