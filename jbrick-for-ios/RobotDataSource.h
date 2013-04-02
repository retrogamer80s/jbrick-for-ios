//
//  RobotDataSource.h
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import <Foundation/Foundation.h>

@interface RobotDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *robotNames;
    NSMutableArray *robotIDs;
    UITableView *tblV;
    UINavigationController *navController;

}

-(id)init:(UITableView *)tableView navController:(UINavigationController *)navCont;

@end
