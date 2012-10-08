//
//  UITextFieldStrongDelegate.h
//  jbrick-for-ios
//
//  Created by Student on 10/1/12.
//
//

#import <UIKit/UIKit.h>

@interface UITextFieldStrongDelegate : UITextField
{
    id<UITextFieldDelegate> inputDelegate;
}
-(id)initWithFrame:(CGRect)frame inputDelegate:(id<UITextFieldDelegate>)delegate;
@end
