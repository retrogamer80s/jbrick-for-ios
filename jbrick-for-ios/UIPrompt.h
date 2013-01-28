//
//  UIPrompt.h
//  jbrick-for-ios
//
//  Created by Student on 1/28/13.
//
//

#import <UIKit/UIKit.h>

typedef void (^onResponseType)(Boolean response);

@interface UIPrompt : NSObject <UIAlertViewDelegate>
{
    onResponseType onResponse;
    UIAlertView *innerAlert;
    Boolean result;
}
- (void)prompt:(NSString *)message title:(NSString *)title onResponse:(onResponseType)onRespondedBlock;
- (Boolean)promptBlocking:(NSString *)message title:(NSString *)title;

@end
