//
//  ConstantValueBlocks.m
//  jbrick-for-ios
//
//  Created by Student on 10/17/12.
//
//

#import "ConstantValueBlocks.h"
#import "ValueCodeBlock.h"

@implementation ConstantValueBlocks
-(id)init
{
    self = [super init];
    constants = [NSMutableDictionary dictionary];
    return self;
}

-(NSArray *) getValueConstants:(Primative)type
{
    if([constants objectForKey:[NSNumber numberWithInt:type]])
        return [constants objectForKey:[NSNumber numberWithInt:type]];
    else
        return [self populateConstants:type];
}

-(NSArray *) populateConstants:(Primative)type
{
    switch (type) {
        case INTEGER:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
        case BOOLEAN:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
        case STRING:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
        case FLOAT:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
        case LONG:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
        case MOTOR:
            [constants setObject:[NSArray arrayWithObjects:
                                  [[ValueCodeBlock alloc] init:type value:@"OUT_A"],
                                  [[ValueCodeBlock alloc] init:type value:@"OUT_B"],
                                  [[ValueCodeBlock alloc] init:type value:@"OUT_C"],
                                  [[ValueCodeBlock alloc] init:type value:@"OUT_AB"],
                                  [[ValueCodeBlock alloc] init:type value:@"OUT_AC"],
                                  [[ValueCodeBlock alloc] init:type value:@"OUT_BC"],
                                  [[ValueCodeBlock alloc] init:type value:@"OUT_ABC"],
                                  nil]
                          forKey:[NSNumber numberWithInt:type]];
            break;
        case MOTOR_POWER:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
        case TONE:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
        case LCD_LINE:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
        case VOID:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
    }
    return [constants objectForKey:[NSNumber numberWithInt:type]];
}
@end
