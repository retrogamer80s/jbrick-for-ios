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

@implementation RobotDataSource

-(id)init:(UITableView *)tableView navController:(UINavigationController *)navCont{
    self = [super init];
    
    tblV = tableView;
    navController = navCont;
    
    NSURL *url = [NSURL URLWithString:@"http://media-server.cjpresler.com/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [httpClient  getPath:@"rest/Devices" parameters:nil
     success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSString *responseStr = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        
        id jsonRobots = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONWritingPrettyPrinted error:nil];
        NSArray *robots =  [NSArray arrayWithArray:jsonRobots];
        
        robotNames = [NSMutableArray array];
        robotIDs = [NSMutableArray array];
        for (NSDictionary *robotDict in robots) {
            [robotNames addObject:[robotDict valueForKey:@"Name"]];
            [robotIDs addObject:[robotDict valueForKey:@"ID"]];
        }
         
        [tblV reloadData];
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];

    
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
