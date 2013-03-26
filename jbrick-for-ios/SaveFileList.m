//
//  SaveFileList.m
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import "SaveFileList.h"

@implementation SaveFileList

-(id)init{
    self = [super init];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    saveFiles = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:rootPath error:nil]];
    for (int i=0; i<saveFiles.count; i++) {
        [saveFiles setObject:[[saveFiles objectAtIndex:i] stringByDeletingPathExtension] atIndexedSubscript:i];
    }
    
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain  reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [saveFiles objectAtIndex:[indexPath row]];
    //if([selID isEqualToString:[robotIDs objectAtIndex:indexPath.row]])
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //else
        //cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return saveFiles.count;
}

@end
