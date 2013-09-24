//
//  MethodTabelCell.h
//  jbrick-for-ios
//
//  Created by Student on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * This is a customized TableCell that supports expanding when clicked
 * to show more content and minimizing when clicking again. This is used
 * to display the codeBlocks in the list where clicking them will give
 * more information about the block.
 */
@interface MethodTabelCell : UITableViewCell {
    bool expanded;
}

/** The Description of the cell that is hidden when not expanded */
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
/** List of parameters for the given block, also hidden when not expanded */
@property (weak, nonatomic) IBOutlet UILabel *ParametesLabel;
/** The main label that shows both when expanded and collapsed */
@property (nonatomic) IBOutlet UILabel* customLabel;
/** Is the cell currently expanded */
@property bool Expanded;
/** Height of the cell currently */
@property (readonly) float Height;

@end
