//
//  ProgramPane.h
//  jbrick-for-ios
//
//  Created by Student on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIBlock; @class jbrickDetailViewController;

/**
 * This represents an instance of the program pane, which is where all the UIBlocks are placed.
 * It is intended to be designed in such a way that you could switch between program panes
 * to modify different applications with ease. This feature is not currently implimented.
 */
@interface ProgramPane : UIScrollView <UIScrollViewDelegate, UITextFieldDelegate>
{
    UIView *zoomableView;
    UIBlock *rootBlock;
    UILabel *programName;
}

/** The trash can image rezides in the bottom right of the ProgramPane. */
@property UIImageView *TrashCan;
/** A list of the blocks currently placed into the ProgramPane. */
@property NSMutableArray *PlacedBlocks;
/** A arrow that shows where the block will be inserted into the program. This is hidden when a block is not being moved */
@property UIImageView *InsertArrow;

/**
 * Resize the ProgramPane to fit all the blocks.
 */
- (void)fitToContent;

/**
 * Returns the highest level block in the ProgramPane (typically the main block).
 * @return The highest level UIBlock
 */
-(UIBlock *)getRootBlock;

/**
 * Populates the ProgramPane with all the blocks under the given rootBlock.
 * @param rootBlock The new rootBlock that all UIBlocks reside under
 * @param dvc The DetailViewController
 */
-(void) loadProgram:(UIBlock *)rootBlock controller:(jbrickDetailViewController *)dvc;

/**
 * Set the position for the block insert arrow, this is the arrow that shows
 * where the block being moved will be inserted if released.
 * @param x The X position
 * @param y The Y position
 */
-(void) setInsertArrowPosition:(int)x y:(int)y;

/**
 * Converts a point from the blockList view to the ProgramPane's internal view
 * @param point The point to be converted
 * @param view the View it is coming from
 * @return The point converted into the ProgramPane's coordinate system
 */
-(CGPoint) convertPointFromList:(CGPoint)point fromView:(UIView *)view;
@end
