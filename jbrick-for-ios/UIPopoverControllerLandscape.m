//
//  UIPopoverControllerLandscape.m
//  jbrick-for-ios
//
//  Created by Student on 4/23/13.
//
//

#import "UIPopoverControllerLandscape.h"

@implementation UIPopoverControllerLandscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
@end
