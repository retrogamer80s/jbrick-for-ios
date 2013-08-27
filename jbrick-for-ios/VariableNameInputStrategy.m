//
//  VariableNameInputStrategy.m
//  jbrick-for-ios
//
//  Created by Student on 4/25/13.
//
//

#import "VariableNameInputStrategy.h"
#import "ValueCodeBlock.h"

@implementation VariableNameInputStrategy
-(id) initWithPrim:(Primative)primative{
    return [super init];
}

-(BOOL)VerifyInput:(NSString *)input{
    NSString *myRegex = @"[A-Za-z]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    return [myTest evaluateWithObject:input];
}

-(CodeBlock *)GetCodeBlock:(id)value
{
    //Add quotes around the entered text. Could possibly escape any quotes within the text as well
    return [[ValueCodeBlock alloc] init:PARAMETER_NAME value:[NSString stringWithFormat:@"%@", value]];
}
@end
