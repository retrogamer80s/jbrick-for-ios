//
//  SaveFileList.h
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import <Foundation/Foundation.h>
#import "jbrickDetailViewController.h"

@interface SaveFileList : NSObject <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>{
    NSMutableArray *saveFiles;
    jbrickDetailViewController *detailView;
    UITableView *_tableView;
    UIBarButtonItem *editButton;
    NSMutableArray *textFields;
    NSString *previousProgramName;
}

-(id)init:(jbrickDetailViewController *)detailView table:(UITableViewController *)table;
-(void)addProgram;
-(void)setEditingMode;

@end
