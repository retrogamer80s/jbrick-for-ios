//
//  ConstantValueBlocks.m
//  jbrick-for-ios
//
//  Created by Student on 10/17/12.
//
//

#import "ConstantValueBlocks.h"
#import "ValueCodeBlock.h"
#import "PrimativeTypeUtility.h"

@implementation ConstantValueBlocks
static NSMutableDictionary *constants;

+(NSArray *) getValueConstants:(Primative)type
{
    if(!constants)
        constants = [NSMutableDictionary dictionary];
    if([constants objectForKey:[NSNumber numberWithInt:type]])
        return [constants objectForKey:[NSNumber numberWithInt:type]];
    else
        return [self populateConstants:type];
}

+(NSArray *) populateConstants:(Primative)type
{
    switch (type) {
        case INTEGER:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
        case BOOLEAN:
            [constants setObject:[NSArray arrayWithObjects:
                                  [[ValueCodeBlock alloc] init:type value:@"true"],
                                  [[ValueCodeBlock alloc] init:type value:@"false"],
                                  nil]
                          forKey:[NSNumber numberWithInt:type]];
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
        case PORT:
            [constants setObject:[NSArray arrayWithObjects:
                                  [[ValueCodeBlock alloc] init:type value:@"S1"],
                                  [[ValueCodeBlock alloc] init:type value:@"S2"],
                                  [[ValueCodeBlock alloc] init:type value:@"S3"],
                                  [[ValueCodeBlock alloc] init:type value:@"S4"],
                                  nil]
                        forKey:[NSNumber numberWithInt:type]];
             break;
        case SENSOR_TYPE:
            [constants setObject:[NSArray arrayWithObjects:
                                  [[ValueCodeBlock alloc] init:type value:@"SENSOR_TYPE_TOUCH"],
                                  [[ValueCodeBlock alloc] init:type value:@"SENSOR_TYPE_LIGHT"],
                                  [[ValueCodeBlock alloc] init:type value:@"SENSOR_TYPE_SOUND_DB"],
                                  [[ValueCodeBlock alloc] init:type value:@"SENSOR_TYPE_TEMPERATURE"],
                                  nil]
                          forKey:[NSNumber numberWithInt:type]];
            break;
        case VOID:
            [constants setObject:[NSArray array] forKey:[NSNumber numberWithInt:type]];
            break;
        case PARAMETER_RETURN:
            [constants setObject:[NSArray arrayWithObjects:
                                  [[ValueCodeBlock alloc] init:INTEGER value:[PrimativeTypeUtility primativeToName:INTEGER]],
                                  [[ValueCodeBlock alloc] init:BOOLEAN value:[PrimativeTypeUtility primativeToName:BOOLEAN]],
                                  [[ValueCodeBlock alloc] init:STRING value:[PrimativeTypeUtility primativeToName:STRING]],
                                  [[ValueCodeBlock alloc] init:FLOAT value:[PrimativeTypeUtility primativeToName:FLOAT]],
                                  [[ValueCodeBlock alloc] init:LONG value:[PrimativeTypeUtility primativeToName:LONG]],
                                  [[ValueCodeBlock alloc] init:MOTOR value:[PrimativeTypeUtility primativeToName:MOTOR]],
                                  [[ValueCodeBlock alloc] init:MOTOR_POWER value:[PrimativeTypeUtility primativeToName:MOTOR_POWER]],
                                  [[ValueCodeBlock alloc] init:TONE value:[PrimativeTypeUtility primativeToName:TONE]],
                                  [[ValueCodeBlock alloc] init:LCD_LINE value:[PrimativeTypeUtility primativeToName:LCD_LINE]],
                                  nil]
                          forKey:[NSNumber numberWithInt:type]];
            break;
        case MATH_OPERATION:
            [constants setObject:[NSArray arrayWithObjects:
                                  [[ValueCodeBlock alloc] init:type value:@"+"],
                                  [[ValueCodeBlock alloc] init:type value:@"-"],
                                  [[ValueCodeBlock alloc] init:type value:@"*"],
                                  [[ValueCodeBlock alloc] init:type value:@"/"],
                                  nil]
                          forKey:[NSNumber numberWithInt:type]];
            break;
            
        case LOGIC_OPERATION:
            [constants setObject:[NSArray arrayWithObjects:
                                  [[ValueCodeBlock alloc] init:type value:@"||"],
                                  [[ValueCodeBlock alloc] init:type value:@"&&"],
                                  [[ValueCodeBlock alloc] init:type value:@"=="],
                                  [[ValueCodeBlock alloc] init:type value:@"!"],
                                  nil]
                          forKey:[NSNumber numberWithInt:type]];
            break;

    }
    return [constants objectForKey:[NSNumber numberWithInt:type]];
}
@end
