//
//  UITextFieldStrongDelegate.m
//  jbrick-for-ios
//
//  Created by Student on 10/1/12.
//
//

#import "UITextFieldStrongDelegate.h"

@implementation UITextFieldStrongDelegate

- (id)initWithFrame:(CGRect)frame inputDelegate:(id<UITextFieldDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        inputDelegate = delegate;
        [self setDelegate:inputDelegate];
        
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"enter text";
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.returnKeyType = UIReturnKeyDone;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

@end
