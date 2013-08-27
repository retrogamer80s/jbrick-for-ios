//
//  ProgramPane.h
//  jbrick-for-ios
//
//  Created by Student on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIBlock; @class jbrickDetailViewController;

@interface ProgramPane : UIScrollView <UIScrollViewDelegate, UITextFieldDelegate>
{
    UIView *zoomableView;
    UIBlock *rootBlock;
    UILabel *programName;
}
@property UIImageView *TrashCan;
@property NSMutableArray *PlacedBlocks;
@property UIImageView *InsertArrow;
- (void)fitToContent;
-(UIBlock *)getRootBlock;
-(void) loadProgram:(UIBlock *)rootBlock controller:(jbrickDetailViewController *)dvc;
-(void) setInsertArrowPosition:(int)x y:(int)y;
-(CGPoint) convertPointFromList:(CGPoint)point fromView:(UIView *)view;
@end
