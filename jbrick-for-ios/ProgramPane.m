//
//  ProgramPane.m
//  jbrick-for-ios
//
//  Created by Student on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgramPane.h"

@implementation ProgramPane

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInitialization];
    }
    return self;
}

- (void)customInitialization
{
    [self setDelegate:self];
    
    CGRect contentRect = self.frame;
    contentRect.origin.x += 5;
    contentRect.origin.y += 5;
    contentRect.size.width -= 5;
    contentRect.size.height -= 5;
    zoomableView = [[UIView alloc] initWithFrame:contentRect];
    zoomableView.clipsToBounds = NO;
    
    [super addSubview:zoomableView];
}

- (void)addSubview:(UIView *)view
{
    [zoomableView addSubview:view];
}

- (void) fitToContent
{
    NSNumber *furthestLeft = nil;
    NSNumber *furthestRight = nil;
    NSNumber *furthestUp = nil;
    NSNumber *furthestDown = nil;
    for (UIView* view in zoomableView.subviews)
    {
        if(furthestLeft == nil || view.frame.origin.x < furthestLeft.floatValue)
            furthestLeft = [NSNumber numberWithFloat:view.frame.origin.x];
        if(furthestRight == nil || view.frame.origin.x + view.frame.size.width > furthestRight.floatValue)
            furthestRight = [NSNumber numberWithFloat:view.frame.origin.x + view.frame.size.width];
        if(furthestUp == nil || view.frame.origin.y < furthestUp.floatValue)
            furthestUp = [NSNumber numberWithFloat:view.frame.origin.y];
        if(furthestDown == nil || view.frame.origin.y + view.frame.size.height > furthestDown.floatValue)
            furthestDown = [NSNumber numberWithFloat:view.frame.origin.y + view.frame.size.height]; 
    }
    
    if(furthestUp.floatValue < 0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            for (UIView *view in zoomableView.subviews)
                view.center = CGPointMake(view.center.x, view.center.y + (furthestUp.floatValue * -1));
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            for (UIView *view in zoomableView.subviews)
                view.center = CGPointMake(view.center.x, view.center.y - furthestUp.floatValue);
        }];
    }
    
    if(furthestLeft.floatValue < 0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            for (UIView *view in zoomableView.subviews)
                view.center = CGPointMake(view.center.x + (furthestLeft.floatValue * -1), view.center.y);
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            for (UIView *view in zoomableView.subviews)
                view.center = CGPointMake(view.center.x - furthestLeft.floatValue, view.center.y);
        }];
    }
    CGSize canvasSize = (CGSizeMake(furthestRight.floatValue - furthestLeft.floatValue, furthestDown.floatValue - furthestUp.floatValue));
    [zoomableView setFrame:CGRectMake(5, 5,canvasSize.width-5, canvasSize.height-5)];
    [UIView animateWithDuration:0.5 animations:^{
        [self setContentSize:canvasSize];
    }];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //Return zoomableView to enable zooming... but it's buggy right now
    return nil;
}

@end
