//
//  VariableAssignmentDelegate.h
//  jbrick-for-ios
//
//  Created by Student on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodeBlock.h"
#import "ValueCodeBlock.h"
#import "ValueInputStrategy.h"

@interface VariableAssignmentDelegate : NSObject <UITextFieldDelegate>
{
    Primative type;
    id<ValueInputStrategy> inputStrategy;
}

@property (nonatomic, retain) CodeBlock * value;
@property (nonatomic, retain) UILabel * valueLabel;

-(id) init:(CodeBlock *)codeBlock;
- (void)sliderDoneEditing:(UISlider *)slider;
- (void)sliderChanged:(UISlider *)slider;
@end
