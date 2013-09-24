//
//  ValueCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewableCodeBlock.h"

/**
 * This block is the smallest unit of a block. It represents a hard-coded value.
 * This class is also used in some cases to store things like a variables name.
 */
@interface ValueCodeBlock : CodeBlock <ViewableCodeBlock>
{
    CodeBlock * type;
    CodeBlock * valueBlock;
    NSString *displayName;
    NSArray *propertyNames;
}

/** The string value of this block */
@property (nonatomic, copy) NSString *Value;
-(id) init:(Primative)type;
-(id) init:(Primative)type value:(NSString *)value;
-(id) init:(Primative)type value:(NSString *)value displayName:(NSString *)dispName;
@end
