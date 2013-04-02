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
    NSMutableArray *textFields;
    NSString *previousProgramName;
}

-(id)init:(jbrickDetailViewController *)detailView tableView:(UITableView *)tableView;
-(void)addProgram;
-(void)setEditingMode;

@end
