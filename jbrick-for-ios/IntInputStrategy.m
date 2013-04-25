//
//  IntInputStrategy.m
//  jbrick-for-ios
//
//  Created by Student on 10/2/12.
//
//

#import "IntInputStrategy.h"

@implementation IntInputStrategy
-(id)initWithPrim:(Primative)primative
{
    self = [super init];
    type = primative;
    return self;
}

-(BOOL)VerifyInput:(NSString *)input
{
    /*  limit to only numeric characters  */
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [input length]; i++) {
        unichar c = [input characterAtIndex:i];
        if (![myCharSet characterIsMember:c]) {
            if(i != 0 || c != '-') // Only the first character may be a negative sign
                return NO;
        }
    }
    
    return YES;
}

-(CodeBlock *)GetCodeBlock:(id)value
{
    return [[ValueCodeBlock alloc] init:type value:value];
}
@end
