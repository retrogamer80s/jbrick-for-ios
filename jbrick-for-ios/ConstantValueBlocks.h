//
//  ConstantValueBlocks.h
//  jbrick-for-ios
//
//  Created by Student on 10/17/12.
//
//

#import <Foundation/Foundation.h>
#import "PrimativeTypes.h"

/**
 * Contains all of the constant values for each type of block.
 * Such as the boolean values True and False.
 */
@interface ConstantValueBlocks : NSObject
+(NSArray *) getValueConstants:(Primative)type;
@end
