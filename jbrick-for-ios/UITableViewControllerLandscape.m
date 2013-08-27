//
//  UITableViewControllerLandscape.m
//  jbrick-for-ios
//
//  Created by Student on 4/9/13.
//
//

#import "UITableViewControllerLandscape.h"

// Operates exactly as a normal UITableViewController but instead only supports
// Landscape orientations. This is needed to support ios 5.1
@interface UITableViewControllerLandscape ()

@end

@implementation UITableViewControllerLandscape
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
@end
