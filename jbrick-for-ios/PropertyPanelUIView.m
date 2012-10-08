//
//  PropertyPanelUIView.m
//  jbrick-for-ios
//
//  Created by Student on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PropertyPanelUIView.h"

@implementation PropertyPanelUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self privateInitializer];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self privateInitializer];
    }
    return self;
}

- (void)privateInitializer
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

- (void) tapped:(UITapGestureRecognizer *)gestureRecognizer{
        //Swallow the tap event so it isn't triggered on the canvas
}

- (BOOL)isOpen{
    return self.frame.origin.x < self.superview.frame.size.width;
}

-(void)setPanelContents:(UIView *)newContent
{
    [self closePanel:^(BOOL finished) {
        if(contents)
            [contents removeFromSuperview];
        
        contents = newContent;
        [self resizeChildViews:contents];
        contents.frame = CGRectMake(10, 60, 180, contents.frame.size.height);
        [self addSubview:contents];
        [self openPanel:nil];
        
    }];
    
}

-(void)closePanel:(void (^)(BOOL finished))completion
{
    if(self.frame.origin.x < self.superview.frame.size.width)
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = CGPointMake(self.center.x + self.frame.size.width, self.center.y);
                         }completion:completion];
    else
        if(completion)
            completion(false);
}

-(void)openPanel:(void (^)(BOOL finished))completion
{
    if(self.frame.origin.x >= self.superview.frame.size.width)
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = CGPointMake(self.center.x - self.frame.size.width, self.center.y);
                         }];
    else
        if(completion)
            completion(false);
    
}

//********* Private Methods ********
-(void)resizeChildViews:(UIView *)view
{
    for(UIView *childView in view.subviews)
        [self resizeChildViews:childView];
    
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 180, view.frame.size.height);
}

@end
