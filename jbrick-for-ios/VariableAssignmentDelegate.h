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
#import "IntInputStrategy.h"
#import "StringInputStrategy.h"

@interface VariableAssignmentDelegate : NSObject <UITextFieldDelegate>
{
    Primative type;
    id<ValueInputStrategy> inputStrategy;
}

@property (nonatomic, retain) id<CodeBlock> value;

-(id) init:(Primative)type;
- (void)sliderChanged:(UISlider *)slider;
@end
