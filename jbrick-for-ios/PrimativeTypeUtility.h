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

@interface PrimativeTypeUtility : NSObject 
+ (NSString *) getDefaultValue:(Primative)primative;
+ (NSString *) getDefaultValueWithNum:(NSNumber *)primative;
+ (NSString *) primativeToString:(Primative)primative;
+ (NSString *) primativeToName:(Primative)primative;
+ (UIView *) constructDefaultView:(Primative)primative delegate:(VariableAssignmentDelegate *)delegate value:(id<CodeBlock>)value;
+ (Boolean) primativeIsUserSelectable:(Primative)type;
@end
