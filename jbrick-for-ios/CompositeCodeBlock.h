//
//  CompositeCodeBlock.h
//  jbrick-for-ios
//
//  Created by Student on 2/6/13.
//
//

#import "CodeBlock.h"
// This is intended to be an abstract block that holds the logic for
// blocks that contain other blocks, such as the logic for adding
// child blocks
@interface CompositeCodeBlock : CodeBlock
{
    NSMutableArray *innerCodeBlocks;
}
-(id) init;

@end
