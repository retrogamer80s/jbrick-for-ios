//
//  ProgramPane.m
//  jbrick-for-ios
//
//  Created by Student on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgramPane.h"
#import "UIBlock.h"
#import "Settings.h"

#define MARGIN_SIDE 5
#define MARGIN_TOP_BOTTOM 35
#define INSERT_ARROW_WIDTH 50
#define INSERT_ARROW_HEIGHT 40

@implementation ProgramPane

@synthesize TrashCan = trashCan;
@synthesize PlacedBlocks;

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
    
    self.PlacedBlocks = [NSMutableArray array];
    
    CGRect contentRect = self.frame;
    contentRect.origin.x += MARGIN_SIDE;
    contentRect.origin.y += MARGIN_TOP_BOTTOM;
    contentRect.size.width -= MARGIN_SIDE;
    contentRect.size.height -= MARGIN_TOP_BOTTOM;
    zoomableView = [[UIView alloc] initWithFrame:contentRect];
    zoomableView.clipsToBounds = NO;
    
    if(!programName){
        CGRect frame = self.frame;
        frame.size.height = 30;
        programName = [[UILabel alloc] initWithFrame:frame];
        [programName setTextColor:[UIColor whiteColor]];
        programName.backgroundColor = [UIColor clearColor];
        programName.font = [UIFont boldSystemFontOfSize:25];
        programName.textAlignment = NSTextAlignmentCenter;
    }
    [programName setText:[Settings settings].CurrentProgram];
    
    if(!self.InsertArrow){
        self.InsertArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-arrow.png"]];
        self.InsertArrow.frame = CGRectMake(0, 0, 50, 40);
        //self.InsertArrow.hidden = YES;
        [self setInsertArrowPosition:0 y:0];
    }
    
    [super addSubview:zoomableView];
    [super addSubview:programName];
    [super addSubview:self.InsertArrow];
}

- (UIBlock *) getRootBlock
{
    return rootBlock;
}

- (void)loadProgram:(UIBlock *)newRootBlock controller:(jbrickDetailViewController *)dvc
{
    if(rootBlock){ // Another program is already loaded, animate it off screen
        UIView *oldZoomView = zoomableView;
        [UIView animateWithDuration:.5 animations:^{
            CGPoint center = zoomableView.center;
            zoomableView.center = CGPointMake(center.x+1000, center.y);
        }];
        
        [self customInitialization];
        rootBlock = newRootBlock;
        [rootBlock initializeControllers:self Controller:dvc];
        [self fitToContent];
        CGPoint center = zoomableView.center;
        zoomableView.center = CGPointMake(center.x-1000, center.y);
        [UIView animateWithDuration:.5 animations:^{
            zoomableView.center = center;
        } completion:^(BOOL finished) {
            [oldZoomView removeFromSuperview];
        }];

    } else {
        rootBlock = newRootBlock;
        [rootBlock initializeControllers:self Controller:dvc];
        [self fitToContent];
    }
}

-(CGPoint) convertPointFromList:(CGPoint)point fromView:(UIView *)view{
    return [zoomableView convertPoint:point fromView:view];
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
    CGSize canvasSize = (CGSizeMake(furthestRight.floatValue - furthestLeft.floatValue, furthestDown.floatValue - furthestUp.floatValue+MARGIN_TOP_BOTTOM + 20));
    [zoomableView setFrame:CGRectMake(MARGIN_SIDE, MARGIN_TOP_BOTTOM, canvasSize.width-MARGIN_SIDE, canvasSize.height-MARGIN_TOP_BOTTOM)];
    [UIView animateWithDuration:0.5 animations:^{
        [self setContentSize:canvasSize];
    }];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //Return zoomableView to enable zooming... but it's buggy right now
    return nil;
}

-(void) setInsertArrowPosition:(int)x y:(int)y
{
    self.InsertArrow.center = CGPointMake(x-(INSERT_ARROW_WIDTH/2), y);
}

@end
