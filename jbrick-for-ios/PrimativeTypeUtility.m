//
//  PrimativeTypeUtility.m
//  jbrick-for-ios
//
//  Created by Student on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrimativeTypeUtility.h"

@implementation PrimativeTypeUtility

+(NSString *)getDefaultValue:(Primative)primative
{
    switch (primative) {
        case STRING:
            return @"\"\"";   
        case BOOLEAN:
            return @"false";
        case MOTOR:
            return @"OUT_A";
        case MOTOR_POWER:
            return @"75";
        case VOID:
            return @"";
        default:
            return @"0";
    }
}

+(NSString *) getDefaultValueWithNum:(NSNumber *)primative
{
    Primative prim = [primative integerValue];
    return [self getDefaultValue:prim];
}

+ (NSString *) primativeToString:(Primative)primative
{
    switch (primative) {
        case INTEGER:
            return @"int";
        case BOOLEAN:
            return @"bool";
        case STRING:
            return @"string";
        case FLOAT:
            return @"float";
        case LONG:
            return @"long";
        case MOTOR:
            return @"byte";
        case MOTOR_POWER:
            return @"int";
        case TONE:
            return @"int";
        case LCD_LINE:
            return @"int";
        case VOID:
            return @"void";
        case -1:
            // Custom case used only for the main block
            return @"task";
        default:
            return nil;
    }
}

+ (NSString *) primativeToName:(Primative)primative
{
    switch (primative) {
        case INTEGER:
            return @"Integer";
        case BOOLEAN:
            return @"Boolean";
        case STRING:
            return @"String";
        case FLOAT:
            return @"Float";
        case LONG:
            return @"Long";
        case MOTOR:
            return @"Motor";
        case MOTOR_POWER:
            return @"Motor Power";
        case TONE:
            return @"Tone";
        case LCD_LINE:
            return @"LCD Line";
        case VOID:
            return @"Void";
        default:
            return nil;
    }
}

+ (UIView *) constructDefaultView:(Primative)primative variableArray:(NSMutableArray *)variables index:(NSInteger)index
{
    VariableAssignmentDelegate *delegate = [[VariableAssignmentDelegate alloc] init:variables index:index returnType:primative];
    ValueCodeBlock *value = nil;
    if([[variables objectAtIndex:index] isKindOfClass:[ValueCodeBlock class]])
        value = [variables objectAtIndex:index];
    
    switch (primative) {
        case MOTOR_POWER:
        {
            UISlider *slider = [[UISliderStrongReference alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
            [slider addTarget:delegate action:@selector(sliderChanged:) forControlEvents:UIControlEventTouchUpInside];
            if(value)
                [slider setValue:[value.Value floatValue] animated:YES];
            return slider;
        }
            
        default:
        {
            UITextField *view = [[UITextFieldStrongDelegate alloc] initWithFrame:CGRectMake(0, 0, 400, 40) inputDelegate:delegate];
            [view setPlaceholder:[PrimativeTypeUtility primativeToName:primative]];
            if(value)
                view.text = value.Value;
            return view;
        }
    }
}
@end
