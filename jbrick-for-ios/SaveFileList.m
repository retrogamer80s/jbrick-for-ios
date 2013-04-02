//
//  SaveFileList.m
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import "SaveFileList.h"
#import "Settings.h"

@implementation SaveFileList

-(id)init:(jbrickDetailViewController *)detailViewParam tableView:(UITableView *)tableView{
    self = [super init];
    
    detailView = detailViewParam;
    _tableView = tableView;
    
    [self findSavedPrograms];
    
    return self;
}

- (void)addProgram
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Program Name" message:@"What should the new program be called?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){ // Okay was pressed
        [self loadProgram:[[alertView textFieldAtIndex:0]text]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain  reuseIdentifier:CellIdentifier];
    
    NSString *saveName = [saveFiles objectAtIndex:[indexPath row]];
    cell.textLabel.text = saveName;
    if([saveName isEqualToString:[Settings settings].CurrentProgram ])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return saveFiles.count;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *programName = [saveFiles objectAtIndex:indexPath.row];
    [self loadProgram:programName];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) loadProgram:(NSString *)progName
{
    [Settings settings].CurrentProgram = progName;
    [detailView loadNewProgram:progName];
    [self findSavedPrograms];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) findSavedPrograms{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    saveFiles = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:rootPath error:nil]];
    for (int i=0; i<saveFiles.count; i++) {
        [saveFiles setObject:[[saveFiles objectAtIndex:i] stringByDeletingPathExtension] atIndexedSubscript:i];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileName = [NSString stringWithFormat:@"%@.sav", [saveFiles objectAtIndex:indexPath.row]];
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", rootPath, fileName];
        
        [saveFiles removeObjectAtIndex:indexPath.row];
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


@end
