//
//  RobotDataSource.m
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import "RobotDataSource.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "Settings.h"
#import "jbrickServerUtility.h"

@implementation RobotDataSource

-(id)init:(UITableView *)tableView navController:(UINavigationController *)navCont{
    self = [super init];
    
    tblV = tableView;
    navController = navCont;
    
    [[[jbrickServerUtility alloc] init] getRobots:^(NSArray *robots) {
        robotNames = [NSMutableArray array];
        robotIDs = [NSMutableArray array];
        for (NSDictionary *robotDict in robots) {
            [robotNames addObject:[robotDict valueForKey:@"Name"]];
            [robotIDs addObject:[robotDict valueForKey:@"ID"]];
        }
        
        [tblV reloadData];
    } failure:nil];
    
    return self;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return robotIDs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain  reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [robotNames objectAtIndex:[indexPath row]];
    
    NSString *selRobotID = [Settings settings].RobotID;
    if([selRobotID isEqualToString:[robotIDs objectAtIndex:indexPath.row]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [Settings settings].RobotID = [robotIDs objectAtIndex:indexPath.row];
    [navController popViewControllerAnimated:YES];
}

@end
