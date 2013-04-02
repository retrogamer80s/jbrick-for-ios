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

@interface UIBlock : UIView <UIGestureRecognizerDelegate, CodeBlockDelegate, NSCoding>
{
    SystemSoundID snapSound;
    SystemSoundID trashSound;
    SystemSoundID velcroSound;
    bool panelWasOpen;
    
    NSMutableArray *attachedBlocks;
    UIBlock *parentBlock;
    UIBlock *previousBlock;
    UIBlock *previousIndexBlock;
    NSInteger defaultHeight;
    
    bool continueScrolling;
}
@property (nonatomic, retain) jbrickDetailViewController *controller;
@property (nonatomic, retain) ProgramPane *programPane;
@property (nonatomic, retain) CodeBlock<ViewableCodeBlock> *CodeBlock;

- (id)init:(jbrickDetailViewController *)controller codeBlock:(id<ViewableCodeBlock>)codeBlockParam;

- (void)panToPoint:(CGPoint) newCenter scrollToRect:(CGRect)visibleRect;
- (void)snapToGrid;
- (UIBlock *)getHighestParent;
- (void)initializeControllers:(ProgramPane *)progPane Controller:(jbrickDetailViewController *)controller;

@end
