//
//  ProgramPane.h
//  jbrick-for-ios
//
//  Created by Student on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgramPane : UIScrollView <UIScrollViewDelegate>
{
    UIView *zoomableView;
}

- (void)fitToContent;

@end
