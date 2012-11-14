//
//  PrimativeTypes.h
//  jbrick-for-ios
//
//  Created by Student on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PrimativeTypes{
    // User selectable types
    INTEGER,
    BOOLEAN,
    STRING,
    FLOAT,
    LONG,
    MOTOR,
    MOTOR_POWER,
    TONE,
    LCD_LINE,
    VOID,
    
    // Types below this point are used within the system
    // if(Primative < SYSTEM_TYPES) will tell if a type is user selectable
    NON_USER_SELECTABLE,
    
    PARAMETER_NAME,
    PARAMETER_RETURN,
    PARAMETER_VALUE,
    MAIN,
    ANY_VARIABLE,
    MATH_OPERATION
} Primative;


