//
//  ValueInputVerificationStrategy.h
//  jbrick-for-ios
//
//  Created by Student on 10/2/12.
//
//

#import <Foundation/Foundation.h>
#import "CodeBlock.h"

@protocol ValueInputStrategy
-(id) initWithPrim:(Primative)primative;
-(BOOL) VerifyInput:(NSString *)input;
-(CodeBlock *) GetCodeBlock:(id)value;
@end