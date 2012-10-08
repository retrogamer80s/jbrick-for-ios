//
//  StringInputStrategy.m
//  jbrick-for-ios
//
//  Created by Student on 10/2/12.
//
//

#import "StringInputStrategy.h"

@implementation StringInputStrategy
-(id)initWithPrim:(Primative)primative
{
    self = [super init];
    type = primative;
    return self;
}

-(BOOL)VerifyInput:(NSString *)input{
    return YES;
}

-(id<CodeBlock>)GetCodeBlock:(id)value
{
    //Add quotes around the entered text. Could possibly escape any quotes within the text as well
    return [[ValueCodeBlock alloc] init:type value:[NSString stringWithFormat:@"%@", value]];
}
@end
