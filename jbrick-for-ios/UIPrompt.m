//
//  UIPrompt.m
//  jbrick-for-ios
//
//  Created by Student on 1/28/13.
//
//

#import "UIPrompt.h"

@implementation UIPrompt

static UIPrompt *prompt;

+ (void) prompt:(NSString *)message title:(NSString *)title onResponse:(onResponseType)onRespondedBlock
{
    prompt = [[UIPrompt alloc] init];
    [prompt prompt:message title:title onResponse:onRespondedBlock];
}

+ (Boolean) promptBlocking:(NSString *)message title:(NSString *)title
{
    prompt = [[UIPrompt alloc] init];
    return [prompt promptBlocking:message title:title];
}

- (void)prompt:(NSString *)message title:(NSString *)title onResponse:(onResponseType)onRespondedBlock
{
    onResponse = onRespondedBlock;
    innerAlert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"YES"
                                              otherButtonTitles:@"NO", nil];
    
    [innerAlert show];
}

// This method uses a busy loop to block execution of the main thread until the
// prompt has been answered. A busy loop is not a good way of blocking a thread
// but it was the only solution I could come up with to stop the main thread
// without halting it (if you do the prompt never gets displayed)
- (Boolean)promptBlocking:(NSString *)message title:(NSString *)title
{
    onResponse = ^(Boolean response){
        result = response;
    };
    innerAlert = [[UIAlertView alloc] initWithTitle:title
                                            message:message
                                           delegate:self
                                  cancelButtonTitle:@"YES"
                                  otherButtonTitles:@"NO", nil];
    
    [innerAlert show];
    
    NSRunLoop *rl = [NSRunLoop currentRunLoop];
    NSDate *d;
    while ([innerAlert isVisible])
    {
        // NSDate init returns 'now'
        d = [[NSDate alloc] init];
        
        // runUntil will run once and stop, since 'now' is 'then
        [rl runUntilDate:d];
    }
    
    return result;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if(onResponse)
                onResponse(true);
            break;
        case 1:
            if(onResponse)
                onResponse(false);
            break;
        default:
            break;
    }
    onResponse = nil;
}


@end
