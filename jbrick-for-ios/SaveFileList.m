//
//  SaveFileList.m
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import "SaveFileList.h"
#import "Settings.h"
#import "EditableTableCell.h"

@implementation SaveFileList

-(id)init:(jbrickDetailViewController *)detailViewParam table:(UITableViewController *)table{
    self = [super init];
    
    detailView = detailViewParam;
    _tableView = table.tableView;
    editButton = table.editButtonItem;
    textFields = [NSMutableArray array];
    
    [self findSavedPrograms];
    
    return self;
}

- (void)addProgram
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Program Name" message:@"What should the new program be called?"
                                                    delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"Program Name";
    alertTextField.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){ // Okay was pressed
        [self loadProgram:[[alertView textFieldAtIndex:0]text]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EditableTableCell";
    EditableTableCell *cell = (EditableTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditableTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.TextField.delegate = self;
    [textFields addObject:cell.TextField];
    NSString *saveName = [saveFiles objectAtIndex:[indexPath row]];
    cell.TextField.text = saveName;
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

- (void)setEditingMode{
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    if(!_tableView.isEditing)
    {
        editButton.style = UIBarButtonItemStylePlain;
        editButton.title = @"Edit";
        
        for(UITextField *tf in textFields)
            tf.userInteractionEnabled = false;
    }
    else
    {
        editButton.style = UIBarButtonItemStyleDone;
        editButton.title = @"Done";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(! tableView.isEditing){
        NSString *programName = [saveFiles objectAtIndex:indexPath.row];
        [self loadProgram:programName];
    } else {
        EditableTableCell *cell = (EditableTableCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.TextField.userInteractionEnabled = YES;
        [cell.TextField becomeFirstResponder];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    previousProgramName = textField.text;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return textField.text.length + string.length - range.length < 12; //Program names on nxt cannot be greater than 11 char
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(previousProgramName && ![@"" isEqual:previousProgramName] && ![textField.text isEqual:previousProgramName]){
        Settings *settings = [Settings settings];
        NSString *orig = [NSString stringWithFormat:@"%@/%@.%@", settings.SaveDirectory, previousProgramName, settings.SaveExtention];
        NSString *dest = [NSString stringWithFormat:@"%@/%@.%@", settings.SaveDirectory, textField.text, settings.SaveExtention];
        
        if([settings.CurrentProgram isEqual:previousProgramName])
            settings.CurrentProgram = textField.text;
        
        [[NSFileManager defaultManager] moveItemAtPath:orig toPath:dest error:nil];
        [self findSavedPrograms];
    }
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
        NSString *progName = [saveFiles objectAtIndex:indexPath.row];
        NSString *rootPath = [Settings settings].SaveDirectory;
        NSString *fileName = [NSString stringWithFormat:@"%@.%@", progName, [Settings settings].SaveExtention];
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", rootPath, fileName];
        
        [saveFiles removeObjectAtIndex:indexPath.row];
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if([[Settings settings].CurrentProgram isEqual:progName]){
            if(saveFiles.count > 0){
                [Settings settings].CurrentProgram = [saveFiles objectAtIndex:0];
                [self loadProgram:[saveFiles objectAtIndex:0]];
            } else {
                //The currently running program was deleted and there are no others to load in
            }
        }
    }

}


@end
