//
//  PrimativeTypeUtility.h
//  jbrick-for-ios
//
//  Created by Student on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrimativeTypes.h"
#import "VariableAssignmentDelegate.h"

#import "UITextFieldStrongDelegate.h"
#import "UISliderStrongReference.h"

/**
 * This is a utility class that provides common functionality for the primative types
 */
@interface PrimativeTypeUtility : NSObject

/**
 * Return the default value for the given type, this will be in the format that NXC
 * dictates.
 * @param primative the type to get the default value for
 * @return Default value of the primative type in NXC syntax
 */
+ (NSString *) getDefaultValue:(Primative)primative;

/**
 * Performs the same operation as GetDefaultValue but alternativley takes the Primative
 * enums number value rather than the enum itself.
 * @param primative the number representing the Primative
 * @return Default value of the Primative type in NXC syntax
 */
+ (NSString *) getDefaultValueWithNum:(NSNumber *)primative;

/**
 * Converts the primative type into it's NXC type equivalent.
 * @param primative the Primative to be converted
 * @return The NXC equivalent type
 */
+ (NSString *) primativeToString:(Primative)primative;

/**
 * Converts the primative to it's display name within the program.
 * @param primative The primative to convert
 * @return The display name of the given Primative
 */
+ (NSString *) primativeToName:(Primative)primative;

/**
 * Create a default UI input for the given Primative. For example
 * passing motor power will construct a slider going from -100 to 100.
 * @param primative The Primative type to create the UI element for
 * @param delegate The VariableAssignmentDelegate that will be called to by the UI input created
 * @param value The current value of the property, used to set the views initial look
 * @return A UIView that can be used to modify the value CodeBlock
 */
+ (UIView *) constructDefaultView:(Primative)primative delegate:(VariableAssignmentDelegate *)delegate value:(CodeBlock *)value;

/**
 * Determine weather or not the primative type is a user type or
 * a system type. A system type is used internally for things like
 * variableName where it is not a NXC type but used to have a consistant
 * interface to change a variables name.
 * @param primative the Primative to test against
 * @return Is the primative user selectable?
 */
+ (Boolean) primativeIsUserSelectable:(Primative)type;
@end
