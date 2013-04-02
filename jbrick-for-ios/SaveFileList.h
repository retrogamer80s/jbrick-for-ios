//
//  SaveFileList.h
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import <Foundation/Foundation.h>
#import "jbrickDetailViewController.h"

@interface SaveFileList : NSObject <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    NSMutableArray *saveFiles;
    jbrickDetailViewController *detailView;
    UITableView *_tableView;
}

-(id)init:(jbrickDetailViewController *)detailView tableView:(UITableView *)tableView;
-(void)addProgram;

@end
