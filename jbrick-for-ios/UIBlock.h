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

typedef enum {
    Inside,
    Above,
    Below
} Direction;

/**
 * Represents the UI element of CodeBlocks in the application.
 * Performs the logic necessary to snap the blocks together and pickup
 * and delete them.
 */
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
    UIBlock *tmpAttachedBlock;
    NSInteger defaultHeight;
    NSNumber *shiftDirection;
    
    bool continueScrolling;
}

@property (nonatomic, retain) jbrickDetailViewController *controller;
@property (nonatomic, retain) ProgramPane *programPane;

/** The CodeBlock that this UIBlock is wrapping around */
@property (nonatomic, retain) CodeBlock<ViewableCodeBlock> *CodeBlock;
/** The frame surrounding this UIBlock without compensating for the block bing shifted over */
@property (readonly) CGRect frameWithoutShift;

- (id)init:(jbrickDetailViewController *)controller codeBlock:(id<ViewableCodeBlock>)codeBlockParam;

/**
 * Animates the UIBlock to the new center point and will ensure that the given
 * rectagle is visible within the program pane, such as scrolling down if you're
 * panning to the bottom of the ProgramPane.
 * @param newCenter The new center point for the UIBlock
 * @param visibleRect The rectangle to ensure is still visible in the ProgramPane
 */
- (void)panToPoint:(CGPoint) newCenter scrollToRect:(CGRect)visibleRect;

/**
 * Snaps the UIBlock into the ProgramPane and associates the related CodeBlocks.
 */
- (void)snapToGrid;

/**
 * Gets the highest level parent of this UIBlock (usually the main block)
 * @return The highest level parent
 */
- (UIBlock *)getHighestParent;

/**
 * The first UIBlock is created before the ProgramPane and DetaileViewController and initialized
 * this method servers to assign them after they have been constructed.
 * @param progPane The ProgramPane associated with the UIBlock
 * @param controller The DetailViewController for the application
 */
- (void)initializeControllers:(ProgramPane *)progPane Controller:(jbrickDetailViewController *)controller;

@end
