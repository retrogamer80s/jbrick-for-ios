//
//  VariableAssignmentDelegate.m
//  jbrick-for-ios
//
//  Created by Student on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VariableAssignmentDelegate.h"

@implementation VariableAssignmentDelegate

-(id) init:(NSMutableArray *)variables index:(NSInteger)index returnType:(Primative)typeParam
{
    self = [super init];
    variableArray = variables;
    variableIndex = index;
    type = typeParam;
    
    [self initInputStrategy];
    
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *concatString = [NSMutableString stringWithString:textField.text];
    [concatString replaceCharactersInRange:range withString:string];
    
    if([inputStrategy VerifyInput:concatString])
    {
        id<CodeBlock> codeBlock = [inputStrategy GetCodeBlock:concatString];
        [variableArray replaceObjectAtIndex:variableIndex withObject:codeBlock];
        
        return YES;
    }
    
    return NO;
}

- (void)sliderChanged:(UISlider *)slider {
    
    id<CodeBlock> codeBlock = [inputStrategy GetCodeBlock:[NSString stringWithFormat:@"%d", (int)roundf(slider.value)]];
    [variableArray replaceObjectAtIndex:variableIndex withObject:codeBlock];
}

- (void)initInputStrategy{
    switch (type) {
        case INTEGER:
            inputStrategy = [[IntInputStrategy alloc] initWithPrim:type];
            break;
        case MOTOR_POWER:
            inputStrategy = [[IntInputStrategy alloc] initWithPrim:type];
            break;
        case STRING:
            inputStrategy = [[StringInputStrategy alloc] initWithPrim:type];
            break;
        default:
            inputStrategy = [[StringInputStrategy alloc] initWithPrim:type];
            break;
    }
}

@end
