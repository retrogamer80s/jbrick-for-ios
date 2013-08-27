//
//  jbrickMasterViewController.h
//  jbrick-for-ios
//
//  Created by Student on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBlock.h"
#import "MethodTabelCell.h"
#import "MGSplitViewController.h"

@class jbrickDetailViewController;

@interface jbrickMasterViewController : UITableViewController {
    bool inDrag;
    UIBlock *draggedView;
    NSIndexPath *selectedIndex;
    NSMutableDictionary *methodBlocks;
    NSMutableArray *reuseCells;
}

@property (strong, nonatomic) jbrickDetailViewController *detailViewController;
@property (strong, nonatomic) MGSplitViewController *splitViewController;
@property (weak, nonatomic) IBOutlet UILabel *ParametersLabel;

@end
