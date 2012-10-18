//
//  VariableDeclorationBlock.h
//  jbrick-for-ios
//
//  Created by Student on 10/17/12.
//
//

#import <Foundation/Foundation.h>
#import "ViewableCodeBlock.h"

@interface VariableDeclorationBlock : NSObject <ViewableCodeBlock>
@property NSString *Name;
-(id) init:(NSString *)variableName type:(Primative)returnType;
@end
