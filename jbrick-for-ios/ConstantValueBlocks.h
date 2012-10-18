//
//  ConstantValueBlocks.h
//  jbrick-for-ios
//
//  Created by Student on 10/17/12.
//
//

#import <Foundation/Foundation.h>
#import "PrimativeTypes.h"

@interface ConstantValueBlocks : NSObject
{
    NSMutableDictionary *constants;
}
-(NSArray *) getValueConstants:(Primative)type;
@end
