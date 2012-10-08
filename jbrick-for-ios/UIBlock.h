//
//  UIBlock.h
//  jbrick-for-ios
//
//  Created by Student on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "jbrickDetailViewController.h"
#import "PrimativeTypes.h"
#import "ProgramPane.h"
#import "ViewableCodeBlock.h"

@interface UIBlock : UIView <UIGestureRecognizerDelegate> 
{
    CGPoint startLocation;
    SystemSoundID snapSound;
    SystemSoundID trashSound;
    SystemSoundID velcroSound;
    bool panelWasOpen;
    
    id<ViewableCodeBlock> codeBlock;
    NSMutableArray *attachedBlocks;
    UIBlock *parentBlock;
    NSInteger defaultHeight;
    
    bool continueScrolling;
}
@property (nonatomic, retain) jbrickDetailViewController *controller;
@property (nonatomic, retain) ProgramPane *programPane;

- (id)init:(jbrickDetailViewController *)controller codeBlock:(id<ViewableCodeBlock>)codeBlockParam;

- (void)panToPoint:(CGPoint) newCenter scrollToRect:(CGRect)visibleRect;
- (void)snapToGrid;

@end
