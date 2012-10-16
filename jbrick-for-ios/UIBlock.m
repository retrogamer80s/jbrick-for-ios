//
//  UIBlock.m
//  jbrick-for-ios
//
//  Created by Student on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIBlock.h"

@implementation UIBlock
@synthesize controller;
@synthesize programPane;

UIBlock *selectedCodeBlock;

static NSMutableArray *placedBlocks;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        if(placedBlocks == nil)
            placedBlocks = [[NSMutableArray alloc] init];
        [placedBlocks addObject:self];
        
        self.userInteractionEnabled = true;
        UILongPressGestureRecognizer *lpGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockTapped:)];
        UITapGestureRecognizer *tripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockTripleTapped:)];
        [tapGesture setNumberOfTapsRequired:1];
        [tripleTapGesture setNumberOfTapsRequired:3];
        
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
- (id)init:(jbrickDetailViewController *)controllerParam codeBlock:(id<ViewableCodeBlock>)codeBlockParam
{
    CGRect frame = CGRectMake(0, 0, 250, 250);
    self = [self initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    controller = controllerParam;
    programPane = controller.programPane;
    codeBlock = codeBlockParam;
    attachedBlocks = [[NSMutableArray alloc]init];
    defaultHeight = frame.size.height;
    
    if(codeBlock.Icon){
        UIImageView *Icon = [[UIImageView alloc]initWithImage:codeBlock.Icon];
        CGFloat aspectRatio = codeBlock.Icon.size.height / codeBlock.Icon.size.width;
        Icon.frame = CGRectMake(15, 15, 50, 50 * aspectRatio);
        [self addSubview:Icon];
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(self != selectedCodeBlock)
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    else
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextSetLineWidth(context, 4.0);
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, codeBlock.BlockColor);
    CGContextSetAlpha(context, .8);
    
    UIBezierPath *strokeRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, rect.size.width-4, rect.size.height-4) cornerRadius:25];
    [strokeRect fill];
    CGContextAddPath(context, strokeRect.CGPath);
    CGContextClosePath(context);
    
    //CGContextFillPath(context);
    CGContextStrokePath(context);

}

- (void)assignSoundID:(NSString *)filename soundID:(SystemSoundID *)soundID
{
    NSString *path= [[NSBundle mainBundle] pathForResource:filename ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, soundID);
}

- (void)panGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{   
    CGPoint translation = [gestureRecognizer locationInView:[self superview]];
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {       
        panelWasOpen = [controller.propertyPane isOpen];
        [controller.propertyPane closePanel:nil];
        AudioServicesPlaySystemSound(velcroSound);
        
        if(parentBlock){
            previousBlock = parentBlock;
            previousIndexBlock = [parentBlock getIndexBlock:self];
            
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
        [self panToPoint:translation scrollToRect:scrollRect];
    }

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self snapToGrid];
        if(panelWasOpen)
            [controller.propertyPane openPanel:nil];
    }
}

- (void)panToPoint:(CGPoint) newCenter scrollToRect:(CGRect)visibleRect
{
    [self bringGroupToFront];
    [self setCenter:CGPointMake(newCenter.x+(self.frame.size.width/2)-20, newCenter.y +(self.frame.size.height/2)-20)];
    
    [self.programPane scrollRectToVisible:visibleRect animated:false];
    
    [self fitToChildren];
}

- (void)snapToGrid
{
    AudioServicesPlaySystemSound(snapSound);
    
    CGRect boundsA = [self convertRect:self.bounds toView:nil];
    UIBlock *overlappedBlock;
    CGFloat distanceToBlock = 0.0;

    for(id object in [self getUnattachedBlocks])
    {
        if(object != self)
        {
            UIBlock *otherBlock = object;
            CGRect boundsB = [otherBlock convertRect:otherBlock.bounds toView:nil];
            if( CGRectIntersectsRect(boundsA, boundsB) ){
                //Check if this one is closer than the previous
                CGFloat otherBlockDistance = [self DistanceBetweenTwoPoints:self.frame.origin point2:otherBlock.frame.origin];
                if(overlappedBlock == nil || otherBlockDistance < distanceToBlock){
                    distanceToBlock = otherBlockDistance;
                    overlappedBlock = otherBlock;
                }
            }
        }
    }
    
    if(overlappedBlock) {
        // Animated Snap to place
        [UIView animateWithDuration:0.5 animations:^{
            //Determine what side to attach to
            float deltaX = self.frame.origin.x - overlappedBlock.frame.origin.x;
            float deltaY = self.frame.origin.y - overlappedBlock.frame.origin.y;

            if(overlappedBlock->parentBlock){
                if(deltaX > 50){
                    [overlappedBlock attachBlockToSide:self indexBlock:nil afterIndexBlock:false];
                } else {
                    if(deltaY <= 0)
                        [overlappedBlock->parentBlock attachBlockToSide:self indexBlock:overlappedBlock afterIndexBlock:false];
                    else
                        [overlappedBlock->parentBlock attachBlockToSide:self indexBlock:overlappedBlock afterIndexBlock:true];
                }
            } else {
                [overlappedBlock attachBlockToSide:self indexBlock:nil afterIndexBlock:false];
            }
        }];
    }
    [programPane fitToContent];
    [programPane scrollRectToVisible:self.frame animated:YES];
    [controller.propertyPane setPropertyContent:[codeBlock getPropertyVariables]];
    
    // Redraw the selection of the current block
    UIBlock *previousSelected = selectedCodeBlock;
    selectedCodeBlock = self;
    [previousSelected setNeedsDisplay];
    [self setNeedsDisplay];
}

-(NSArray *)getUnattachedBlocks{
    NSMutableArray *unattachedBlocks = [NSMutableArray arrayWithArray:placedBlocks];
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

-(void)attachBlockToSide:(UIBlock *)attachBlock indexBlock:(UIBlock *)indexBlock afterIndexBlock:(bool)afterIndexBlock
{
    bool attached = false;
    attachBlock->parentBlock = self;
    if(!indexBlock)
    {
        if([codeBlock addCodeBlock:attachBlock->codeBlock]){
            [attachedBlocks addObject:attachBlock];
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
        if(attachBlock->previousBlock)
            [attachBlock->previousBlock attachBlockToSide:attachBlock indexBlock:attachBlock->previousIndexBlock afterIndexBlock:false];
        else
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

-(void)resizeSelf
{
    NSInteger childHeightSum = 0;
    for(UIBlock *child in attachedBlocks){
        childHeightSum += child.frame.size.height;
    }
    if(childHeightSum == 0)
        childHeightSum = defaultHeight - 60;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, childHeightSum+60);
    [self setNeedsDisplay];
    
    if(parentBlock)
        [parentBlock resizeSelf];
}

-(void)setChildrenSize
{
    for(UIBlock *child in attachedBlocks)
        [child setChildrenSize];
    
    NSInteger childHeightSum = 0;
    for(UIBlock *child in attachedBlocks){
        childHeightSum += child.frame.size.height;
    }
    if(childHeightSum == 0)
        childHeightSum = defaultHeight - 60;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, childHeightSum+60);
    [self setNeedsDisplay];
}

-(void) fitToChildren
{
    for(int i=0; i<[attachedBlocks count]; i++){
        UIBlock *child = [attachedBlocks objectAtIndex:i];
        if(i == 0)
            child.frame = CGRectMake(self.frame.origin.x + 40, self.frame.origin.y + 40, child.frame.size.width, child.frame.size.height);
        else{
            UIBlock *prevChild = [attachedBlocks objectAtIndex:i-1];
            child.frame = CGRectMake(self.frame.origin.x + 40, prevChild.frame.origin.y + prevChild.frame.size.height, child.frame.size.width, child.frame.size.height);
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

- (void)delete
{
    [controller.propertyPane closePanel:nil];
    AudioServicesPlaySystemSound(trashSound);
    
    if(parentBlock){
        [codeBlock removeFromParent];
        [parentBlock->attachedBlocks removeObject:self];
    }
    
    [UIView transitionWithView:self
                      duration:.5
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^ {
                        [self animateDelete];
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

-(void)animateDelete
{
    self.alpha = 0;
    
    for(UIBlock *child in [attachedBlocks copy])
        [child animateDelete];
}

-(void)deleteWithAllChildren
{
    [placedBlocks removeObject:self];
    [self removeFromSuperview];
    for(UIBlock *child in attachedBlocks)
        [child deleteWithAllChildren];
        
}

- (void)blockTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    if(self != selectedCodeBlock || ![controller.propertyPane isOpen])
    {
        [controller.propertyPane setPropertyContent:[codeBlock getPropertyVariables]];
        [controller.propertyPane openPanel:nil];
    }
    if(self != selectedCodeBlock)
    {
        // Redraw the selection of the current block
        UIBlock *previousSelected = selectedCodeBlock;
        selectedCodeBlock = self;
        [previousSelected setNeedsDisplay];
        [self setNeedsDisplay];
    }
}

- (void)blockTripleTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self delete];
}

- (CGFloat) DistanceBetweenTwoPoints:(CGPoint)point1 point2:(CGPoint)point2;
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};


@end
