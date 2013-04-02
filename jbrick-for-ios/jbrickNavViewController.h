//
//  jbrickNavViewController.h
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import <UIKit/UIKit.h>
#import "jbrickMasterViewController.h"

@interface jbrickNavViewController : UINavigationController <UITableViewDelegate>{
    id<UITableViewDataSource, UITableViewDelegate> currentDataSource;
}

@property (strong, nonatomic) jbrickMasterViewController *codeBlockController;
@property (strong, nonatomic) jbrickDetailViewController *detailViewController;
@property (strong, nonatomic) UITableViewController *mainMenuController;

@end
