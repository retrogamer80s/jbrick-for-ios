//
//  ValueCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodeBlock.h"

@interface ValueCodeBlock : NSObject <CodeBlock>
@property (nonatomic, copy) NSString *Value;
-(id) init:(Primative)type;
-(id) init:(Primative)type value:(NSString *)value;
@end
