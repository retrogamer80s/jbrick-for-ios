//
//  VariableAssignmentDelegate.m
//  jbrick-for-ios
//
//  Created by Student on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VariableAssignmentDelegate.h"
#import "IntInputStrategy.h"
#import "StringInputStrategy.h"
#import "VariableNameInputStrategy.h"

@implementation VariableAssignmentDelegate

@synthesize value;

-(id) init:(CodeBlock *)codeBlock
{
    self = [super init];
    value = codeBlock;
    type = codeBlock.ReturnType;
    
    [self initInputStrategy];
    
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *concatString = [NSMutableString stringWithString:textField.text];
    [concatString replaceCharactersInRange:range withString:string];
    
    if([inputStrategy VerifyInput:concatString])
    {
        CodeBlock * codeBlock = [inputStrategy GetCodeBlock:concatString];
        value = codeBlock;
        
        return YES;
    }
    
    return NO;
}

- (void)sliderDoneEditing:(UISlider *)slider {
    
    CodeBlock * codeBlock = [inputStrategy GetCodeBlock:[NSString stringWithFormat:@"%d", (int)roundf(slider.value)]];
    value = codeBlock;
    if(self.valueLabel)
        self.valueLabel.text = @"";
}

- (void)sliderChanged:(UISlider *)slider {
    float output = slider.value;
    int newValue = 5 * floor((output/5)+0.5);
    slider.value = newValue;
    
    if(self.valueLabel)
        self.valueLabel.text = [NSString stringWithFormat:@"%d", newValue];
}

- (void)initInputStrategy{
    switch (type) {
        case INTEGER:
            inputStrategy = [[IntInputStrategy alloc] initWithPrim:type];
            break;
        case LONG:
            inputStrategy = [[IntInputStrategy alloc] initWithPrim:type];
            break;
        case MOTOR_POWER:
            inputStrategy = [[IntInputStrategy alloc] initWithPrim:type];
            break;
        case PARAMETER_NAME:
            inputStrategy = [[VariableNameInputStrategy alloc] initWithPrim:type];
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
