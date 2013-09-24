//
//  CompositeCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 2/6/13.
//
//

#import "CodeBlock.h"
/** 
 * This is intended to be an abstract class that holds the logic for
 * blocks that can have child blocks. This profides a default implimentation
 * for actions like add and removing child blocks.
 */
@interface CompositeCodeBlock : CodeBlock
{
    NSMutableArray *innerCodeBlocks;
}
-(id) init;

/**
 * Determine whether or not the given codeBlock can be addded to this
 * block's sub-blocks.
 * @param codeBlock the block to test adding
 * @return true if the codeBlock can be added
 */
-(bool) canAddCodeBlock:(CodeBlock *)codeBlock;

@end
