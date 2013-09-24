//
//  ValueInputVerificationStrategy.h
//  jbrick-for-ios
//
//  Created by Student on 10/2/12.
//
//

#import <Foundation/Foundation.h>
#import "CodeBlock.h"

/**
 * Represents a input verification class that is used to verify that the user
 * has entered a valid input for a given input type. There are concrete
 * classes for each type of input that need input validation.
 */
@protocol ValueInputStrategy

/**
 * All ValueInputStrategies must impiment an initializer that takes a primative type.
 * @param primative The Primative to be associated with the ValueInputStrategy.
 * @return A pointer to the concrete ValueInputStrategy
 */
-(id) initWithPrim:(Primative)primative;

/**
 * Verify that the input string given is appropriate for the associated primative type.
 * @param input The input string to test validity
 * @return True if the input is valid
 */
-(BOOL) VerifyInput:(NSString *)input;

/**
 * Construct an appropriate CodeBlock from the given value
 * @param value The value to be used in constructing the CodeBlock
 * @return A pointer to the constructed CodeBlock
 */
-(CodeBlock *) GetCodeBlock:(id)value;
@end