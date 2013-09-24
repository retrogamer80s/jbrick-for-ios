//
//  UIBlock.m
//  jbrick-for-ios
//
//  Created by Student on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIBlock.h"
#import "iToast.h"

@interface UIBlock ()
@property CGRect frameWithoutShift;
@end


@implementation UIBlock

@synthesize controller;
@synthesize programPane;
@synthesize CodeBlock = codeBlock;

UIBlock *selectedCodeBlock;

#define TOP_MARGIN 60
#define BOTTOM_MARGIN 30
#define LEFT_MARGIN 40
#define DEFAULT_MINIMIZED_HEIGHT 100
#define DEFAULT_WIDTH 250
#define SHIFT_MARGIN 50


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [programPane.PlacedBlocks addObject:self];
        
        self.userInteractionEnabled = true;
        UILongPressGestureRecognizer *lpGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockTapped:)];
        UITapGestureRecognizer *tripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockTripleTapped:)];
        [tapGesture setNumberOfTapsRequired:1];
        [tripleTapGesture setNumberOfTapsRequired:3];
        lpGesture.minimumPressDuration = .15;
        
        lpGesture.delegate = self;
        tapGesture.delegate = self;
        tripleTapGesture.delegate = self;
        
        [self addGestureRecognizer:lpGesture];  
        [self addGestureRecognizer:tapGesture];
        [self addGestureRecognizer:tripleTapGesture];
        
        [self assignSoundID:@"snap" soundID:&snapSound];
        [self assignSoundID:@"trash" soundID:&trashSound];
        [self assignSoundID:@"velcro" soundID:&velcroSound];
    }
    return self;
}
- (id)init:(jbrickDetailViewController *)controllerParam codeBlock:(CodeBlock<ViewableCodeBlock> *)codeBlockParam
{
    codeBlock = codeBlockParam;
    codeBlock.Delegate = self;
    if(codeBlock.ContainsChildren)
        defaultHeight = DEFAULT_MINIMIZED_HEIGHT + TOP_MARGIN + BOTTOM_MARGIN;
    else
        defaultHeight = DEFAULT_MINIMIZED_HEIGHT;
    CGRect frame = CGRectMake(0, 0, DEFAULT_WIDTH, defaultHeight);
    
    controller = controllerParam;
    programPane = controller.programPane;
    attachedBlocks = [[NSMutableArray alloc]init];
    
    self = [self initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    if(codeBlock.Icon){
        UIImageView *Icon = [[UIImageView alloc]initWithImage:codeBlock.Icon];
        CGFloat aspectRatio = codeBlock.Icon.size.height / codeBlock.Icon.size.width;
        Icon.frame = CGRectMake(15, 15, 50, 50 * aspectRatio);
        [self addSubview:Icon];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, DEFAULT_WIDTH-75, 25)];
    label.text = [codeBlock getDisplayName];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:30];
    [self addSubview:label];
    
    return self;
}

/**
 * This is the main draw method for the block and controls the overall visuals.
 * This is done programatically to allow dynamic sizing.
 */
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(self != selectedCodeBlock)
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    else
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    

    
    CGContextSetLineWidth(context, 4.0);
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, codeBlock.BlockColor.CGColor);
    CGContextSetAlpha(context, .8);
    
    UIBezierPath *strokeRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, rect.size.width-4, rect.size.height-4) cornerRadius:25];
    [strokeRect fill];
    CGContextAddPath(context, strokeRect.CGPath);
    CGContextClosePath(context);
    
    CGContextStrokePath(context);

}

/** Helper method for using the System Sounds API */
- (void)assignSoundID:(NSString *)filename soundID:(SystemSoundID *)soundID
{
    NSString *path= [[NSBundle mainBundle] pathForResource:filename ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, soundID);
}

/**
 * This method is called repeatedly durring the time that a UIBlock is being drug around the screen.
 * Each call to this method should update the blocks position and check to see if the block
 * has been released.
 */
- (void)panGesture:(UIGestureRecognizer *)gestureRecognizer
{
    // Exclude the top level block from being able to be picked up and potentially deleted
    if(parentBlock || previousBlock){
        CGPoint translation = [gestureRecognizer locationInView:[self superview]];
        if([gestureRecognizer state] == UIGestureRecognizerStateBegan)
        {
            [self selectBlock];
            AudioServicesPlaySystemSound(velcroSound);
            
            // If the block being picked up has a parent block, null it out and assigne it to the
            // previousBlock property so we can restore it if need be
            if(parentBlock){
                previousBlock = parentBlock;
                previousIndexBlock = [parentBlock getIndexBlock:self];
                
                // Remove teh CodeBlock within the model as well
                [codeBlock removeFromParent];
                [parentBlock->attachedBlocks removeObject:self];
                [UIView animateWithDuration:.5 animations:^{
                    [parentBlock positionBlockGroup];
                }];
                
            }
            parentBlock = nil;
        }
        
        if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
            CGRect scrollRect = CGRectMake(translation.x > programPane.contentSize.width ? 0 :translation.x, translation.y, 100, 100);
            // Pan the block to the translation position and ensure that the rectagle around the users fingers remains
            // visible incase they are trying to scroll the programPane with a block picked up
            [self panToPoint:translation scrollToRect:scrollRect];
        }
        
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            [self snapToGrid];
            if(panelWasOpen)
                [controller.propertyPane openPanel:nil];
        }
    }
}

-(CGRect)frameWithoutShift{
    CGRect origFrame = self.frame;
    if(shiftDirection){
        switch (shiftDirection.integerValue) {
            case Inside:
                return origFrame;
            case Above:
                return CGRectMake(origFrame.origin.x, origFrame.origin.y - SHIFT_MARGIN, origFrame.size.width, origFrame.size.height);
            case Below:
                return CGRectMake(origFrame.origin.x, origFrame.origin.y + SHIFT_MARGIN, origFrame.size.width, origFrame.size.height);
            default:
                return origFrame;
        }
    } else {
        return origFrame;
    }
}
- (void)setFrameWithoutShift:(CGRect)frameWithoutShift{
    
}

- (void)panToPoint:(CGPoint) newCenter scrollToRect:(CGRect)visibleRect
{
    [self bringGroupToFront];
    [self setCenter:CGPointMake(newCenter.x+(self.frame.size.width/2)-20, newCenter.y +(self.frame.size.height/2)-20)];
    
    [self.programPane scrollRectToVisible:visibleRect animated:false];
    [self fitToChildren];
    
    UIBlock *tmpBlock = [self getClosestBlock];
    [self animateArrow:tmpBlock];
}

- (void)animateArrow:(UIBlock *)insertBlock{
    if(!insertBlock && tmpAttachedBlock){
        tmpAttachedBlock = nil;
        [UIView animateWithDuration:.25 animations:^{
            [programPane setInsertArrowPosition:0 y:programPane.InsertArrow.center.y];
        }];
    } else if(insertBlock){
        double arrowY, arrowX;
        // Get the position for which the new block will be inserted and then
        // construct the Arrows new X and Y values
        switch ([self getAttachDirection:insertBlock]) {
            case Inside:
                arrowX = insertBlock.frame.origin.x + 10 + LEFT_MARGIN;
                arrowY = insertBlock.frame.origin.y+ 35 + TOP_MARGIN;
                break;
            case Below:
                arrowX = insertBlock.frame.origin.x + 10;
                arrowY = insertBlock.frame.origin.y+ 35 + insertBlock.frame.size.height;
                break;
            case Above:
                arrowX = insertBlock.frame.origin.x + 10;
                arrowY = insertBlock.frame.origin.y+ 35;
                break;
        }
        
        if(!tmpAttachedBlock) // The arrow is off the screen
            [programPane setInsertArrowPosition:0 y:insertBlock.frame.origin.y+ 35 + insertBlock.frame.size.height];
        tmpAttachedBlock = insertBlock;
        
        // Animate the arrow to the position the block will be inserted into if released
        [UIView animateWithDuration:.25 animations:^{
            [programPane setInsertArrowPosition:arrowX y:arrowY];
        }];
    }
}

/** Get the block that is phisically closed the this block and above, otherwise get the main block */
- (UIBlock *)getClosestBlock
{
    CGRect boundsA = [self.superview convertRect:self.frame toView:programPane];
    UIBlock *closestBlock;
    CGFloat distanceToClosestBlock = CGFLOAT_MAX;
    
    // Search through all blocks that are not within this blocks children (if you're moving several blocks at once)
    // In each pass record the vertical distance between the two blocks if it's above and less than the previous loop
    for(id object in [self getUnattachedBlocks])
    {
        if(object != self)
        {
            UIBlock *otherBlock = object;
            CGRect boundsB = [otherBlock.superview convertRect:otherBlock.frame toView:programPane];
            double distance = boundsA.origin.y - boundsB.origin.y;
            if(distance > 0 && distance < distanceToClosestBlock && (boundsB.origin.y + boundsB.size.height) >= boundsA.origin.y){
                closestBlock = otherBlock;
                distanceToClosestBlock = distance;
            }
        }
    }
    
    // Main is the closest block, determine where within main to attach
    UIBlock *main = [programPane getRootBlock];
    if(!closestBlock || closestBlock == main){
        NSUInteger blocksInMain = main->attachedBlocks.count;
        CGRect mainBounds = [main.superview convertRect:main.frame toView:programPane];
        if(boundsA.origin.y > mainBounds.origin.y + TOP_MARGIN && blocksInMain > 0)
            closestBlock = [main->attachedBlocks objectAtIndex:blocksInMain-1]; // get the lowest block
        else // Above the main block so return main
            closestBlock = [programPane getRootBlock];
    }
    
    return closestBlock;
} 

/** Determine if this block is being attached inside or below the overlappedBlock */
- (Direction)getAttachDirection:(UIBlock *)overlappedBlock{
    if(overlappedBlock->parentBlock){
        CGPoint orig1 = [self.superview convertPoint:self.frame.origin toView:programPane];
        CGPoint orig2 = [overlappedBlock.superview convertPoint:overlappedBlock.frame.origin toView:programPane];
        double halfway = orig2.y + (overlappedBlock.frame.size.height / 2);
        
        // If the overlapped block can have children and this block is above it's halfway point
        if (overlappedBlock.CodeBlock.ContainsChildren && orig1.y <= halfway){
            return Inside;
        } else {
            return Below;
        }
    } else { // No parent, must be main
        return Inside;
    }
}

- (void)snapToGrid
{
    [self animateArrow:nil];// Remove the arrow
    
    if([self isInDeleteLocation:self.frame]){
        // If it is in the Delete location than it has already started deleting itself so just return
        // without snapping to the grid
        return;
    }
    
    AudioServicesPlaySystemSound(snapSound);
    
    UIBlock *overlappedBlock = [self getClosestBlock];
    if(overlappedBlock) {
        // Animated Snap to place
        [UIView animateWithDuration:0.5 animations:^{
            //Determine what side to attach to
            switch ([self getAttachDirection:overlappedBlock]) {
                case Inside:
                    [overlappedBlock attachBlockToSide:self indexBlock:nil afterIndexBlock:false];
                    break;
                case Above:
                    [overlappedBlock->parentBlock attachBlockToSide:self indexBlock:overlappedBlock afterIndexBlock:false];
                    break;
                case Below:
                    [overlappedBlock->parentBlock attachBlockToSide:self indexBlock:overlappedBlock afterIndexBlock:true];
                    break;
            }
        }];
        [programPane fitToContent];
        [programPane scrollRectToVisible:self.frame animated:YES];
        
        // Redraw the selection of the current block
        [self selectBlock];
    } else {
        
        if(previousBlock) // Could not attach to new location return to previous location
            [UIView animateWithDuration:0.5 animations:^{
                [previousBlock attachBlockToSide:self indexBlock:previousIndexBlock afterIndexBlock:false];
            }];
        else // There was no previous location so remove yourself from the ProgramPane
            [self returnToList];
        
    }
    
}

/** Highlights this block as the selected block and removes the highlight to the previously selected block. */
-(void) selectBlock
{
    [controller.propertyPane setPropertyContent:codeBlock];
    UIBlock *previousSelected = selectedCodeBlock;
    selectedCodeBlock = self;
    [previousSelected setNeedsDisplay];
    [self setNeedsDisplay];
}

-(NSArray *)getUnattachedBlocks{
    NSMutableArray *unattachedBlocks = [NSMutableArray arrayWithArray:programPane.PlacedBlocks];
    [unattachedBlocks removeObjectsInArray:[self getAllChildren:nil]];
    
    return unattachedBlocks;
}

-(NSArray *)getAllChildren:(NSMutableArray *)children{
    if(!children)
        children = [[NSMutableArray alloc]init];
    
    [children addObjectsFromArray:attachedBlocks];
    for(UIBlock *child in attachedBlocks)
        [child getAllChildren:children];
    
    return children;
}

/** Try and attach the given block within this block based on the indexBlock */
-(void)attachBlockToSide:(UIBlock *)attachBlock indexBlock:(UIBlock *)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    bool attached = false;
    attachBlock->parentBlock = self;
    if(!indexBlock)
    {
        // There was no indexBlock so add this block to the front of the children
        if([codeBlock addCodeBlock:attachBlock->codeBlock]){
            [attachedBlocks insertObject:attachBlock atIndex:0];
            attached = true;
        }
    } else {
        NSInteger index = [attachedBlocks indexOfObject:indexBlock];
        if(index != NSNotFound){
            if([codeBlock addCodeBlock:attachBlock->codeBlock indexBlock:indexBlock->codeBlock afterIndexBlock:afterIndexBlock]){
                if(afterIndexBlock)
                    [attachedBlocks insertObject:attachBlock atIndex:index+1];
                else
                    [attachedBlocks insertObject:attachBlock atIndex:index];
                attached = true;
            }
        }
    }
    if(attached)
        [self positionBlockGroup];
    else{
        if(attachBlock->previousBlock) // The block could not be attached return it to it's previous location
            [attachBlock->previousBlock attachBlockToSide:attachBlock indexBlock:attachBlock->previousIndexBlock afterIndexBlock:false];
        else // The block had no previous location so delete it
            [attachBlock delete];
    }
}

-(UIBlock *)getIndexBlock:(UIBlock *)indexBlock
{
    NSInteger index = [attachedBlocks indexOfObject:indexBlock];
    if(index == NSNotFound || index == attachedBlocks.count -1)
        return nil;
    else
        return [attachedBlocks objectAtIndex:index+1];
}

-(void) positionBlockGroup
{
    [self resizeSelf];
    [[self getHighestParent] fitToChildren];
}

/**
 * resize the size of this block based on how many children are present, this call goes recursively up to the main block when
 * a block is added.
 */
-(void)resizeSelf
{
    NSInteger childHeightSum = 0;
    for(UIBlock *child in attachedBlocks){
        childHeightSum += child.frame.size.height;
    }
    if(childHeightSum == 0)
        childHeightSum = defaultHeight - TOP_MARGIN - BOTTOM_MARGIN;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, childHeightSum+TOP_MARGIN+BOTTOM_MARGIN);
    [self setNeedsDisplay];
    
    if(parentBlock)
        [parentBlock resizeSelf];
}

/** Reposition the blocks so they fit within the parent. This call goes recursively down */
-(void) fitToChildren
{
    for(int i=0; i<[attachedBlocks count]; i++){
        UIBlock *child = [attachedBlocks objectAtIndex:i];
        if(i == 0)
            child.frame = CGRectMake(self.frame.origin.x + LEFT_MARGIN, self.frame.origin.y + TOP_MARGIN, child.frame.size.width, child.frame.size.height);
        else{
            UIBlock *prevChild = [attachedBlocks objectAtIndex:i-1];
            child.frame = CGRectMake(self.frame.origin.x + LEFT_MARGIN, prevChild.frame.origin.y + prevChild.frame.size.height, child.frame.size.width, child.frame.size.height);
        }
    }

    for(UIBlock *child in attachedBlocks)
        [child fitToChildren];

}

-(void)bringGroupToFront
{
    [self.superview bringSubviewToFront:self];
    for(UIBlock *child in attachedBlocks)
        [child bringGroupToFront];
}

-(UIBlock *)getHighestParent
{
    if(!parentBlock)
        return self;
    UIBlock *parent = parentBlock;
    while(parent->parentBlock)
        parent = parent->parentBlock;
    
    return parent;
}

/** Return the block to the list because it could not be placed in the ProgramPane */
- (void)returnToList
{
    [[[[iToast makeText:@"Blocks must be placed over other blocks"]
       setDuration:iToastDurationNormal] setGravity:iToastGravityTop ] show];
    
    [UIView animateWithDuration:.5 animations:^{
        self.center = CGPointMake(-150, 300);
    } completion:^(BOOL finished) {
        
    }];
    [self delete];
}

- (void)delete
{
    codeBlock.Deleted = true;
}

/** Perform delete animation on this block and all of it's children */
-(void)performDeleteAnimation
{
    [controller.propertyPane closePanel:nil];
    AudioServicesPlaySystemSound(trashSound);
    [controller.propertyPane setPropertyContent:nil];
    
    if(parentBlock){
        [codeBlock removeFromParent];
        [parentBlock->attachedBlocks removeObject:self];
    }
    [UIView transitionWithView:self
                      duration:.5
                       options:UIViewAnimationOptionTransitionCurlUp | UIViewAnimationOptionAllowAnimatedContent
                    animations:^ {
                        [self deleteAnimation];
                    }
                    completion:^(BOOL finished) {
                        [self removeFromSuperview];
                        [self deleteWithAllChildren];
                        [UIView animateWithDuration:0.5 animations:^{
                            [parentBlock positionBlockGroup];
                        } completion:^(BOOL finished) {
                            [programPane fitToContent];
                        }];
                        
                    }];
}

-(void)deleteAnimation
{
    self.alpha = 0;
    
    for(UIBlock *child in [attachedBlocks copy])
        [child deleteAnimation];
}

-(void)deleteWithAllChildren
{
    [programPane.PlacedBlocks removeObject:self];
    [self removeFromSuperview];
    codeBlock.Deleted = true;
    for(UIBlock *child in attachedBlocks)
        [child deleteWithAllChildren];
        
}

- (void)blockTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [controller.propertyPane openPanel:nil];

    if(self != selectedCodeBlock)
    {
        [self selectBlock];
    }
}

- (void)blockTripleTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    if(parentBlock)
        [self delete];
}

/** Determine if the block is over the trash can and if so call to delete it */
- (bool) isInDeleteLocation:(CGRect)frame
{
    CGRect hitBox = CGRectMake(frame.origin.x, frame.origin.y, 50, 50);
    if(CGRectIntersectsRect(hitBox, [controller.programPane convertRect:controller.programPane.TrashCan.frame fromView:controller.view ]))
    {
        
        [self delete];
        return true;
    }
    return false;
}

- (CGFloat) DistanceBetweenTwoPoints:(CGPoint)point1 point2:(CGPoint)point2;
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
}

-(void)blockWasDeleted:(NSObject *)sender
{
    [self performDeleteAnimation];
}

-(void)blockChangedType:(NSObject *)sender
{
    [controller.propertyPane setPropertyContent:codeBlock];
}

//Encoding/Decoding Methods, these are used when loading a program from file
- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];

    [coder encodeBool:panelWasOpen forKey:@"panelwasOpen"]; 
    [coder encodeObject:codeBlock forKey:@"codeBlock"];
    [coder encodeObject:attachedBlocks forKey:@"attachedBlocks"];
    [coder encodeObject:parentBlock forKey:@"parentBlock"];
    [coder encodeObject:previousBlock forKey:@"previousBlock"];
    [coder encodeObject:previousIndexBlock forKey:@"previousIndexBlock"];
    [coder encodeInt32:defaultHeight forKey:@"defaultHeight"];

}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    panelWasOpen = [coder decodeBoolForKey:@"panelwasOpen"];
    
    codeBlock = [coder decodeObjectForKey:@"codeBlock"];
    codeBlock.Delegate = self;
    
    attachedBlocks = [coder decodeObjectForKey:@"attachedBlocks"];
    parentBlock = [coder decodeObjectForKey:@"parentBlock"];
    previousBlock = [coder decodeObjectForKey:@"previousBlock"];
    previousIndexBlock = [coder decodeObjectForKey:@"previousIndexBlock"];
    defaultHeight = [coder decodeInt32ForKey:@"defaultHeight"];
    
    self.userInteractionEnabled = true;
    UILongPressGestureRecognizer *lpGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockTapped:)];
    UITapGestureRecognizer *tripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockTripleTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tripleTapGesture setNumberOfTapsRequired:3];
    lpGesture.minimumPressDuration = .15;
    
    lpGesture.delegate = self;
    tapGesture.delegate = self;
    tripleTapGesture.delegate = self;
    
    [self addGestureRecognizer:lpGesture];
    [self addGestureRecognizer:tapGesture];
    [self addGestureRecognizer:tripleTapGesture];
    
    [self assignSoundID:@"snap" soundID:&snapSound];
    [self assignSoundID:@"trash" soundID:&trashSound];
    [self assignSoundID:@"velcro" soundID:&velcroSound];
    
    return self;
}

- (void)initializeControllers:(ProgramPane *)progPane Controller:(jbrickDetailViewController *)cont
{
    self.programPane = progPane;
    self.controller = cont;
    
    [programPane.PlacedBlocks addObject:self];
    [programPane addSubview:self];
    
    for (UIBlock *block in attachedBlocks) {
        [block initializeControllers:progPane Controller:cont];
    }
}
@end
