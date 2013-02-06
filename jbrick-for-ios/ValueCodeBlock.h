//
//  ValueCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewableCodeBlock.h"

@interface ValueCodeBlock : CodeBlock <ViewableCodeBlock>
{
    CodeBlock * type;
    CodeBlock * valueBlock;
}
@property (nonatomic, copy) NSString *Value;
-(id) init:(Primative)type;
-(id) init:(Primative)type value:(NSString *)value;
@end
