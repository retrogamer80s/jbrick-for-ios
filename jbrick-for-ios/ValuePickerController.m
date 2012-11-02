//
//  ValuePickerController.m
//  jbrick-for-ios
//
//  Created by Student on 10/15/12.
//
//

#import "ValuePickerController.h"
#import "ValueInputCell.h"
#import "VariableAssignmentDelegate.h"

@implementation ValuePickerController

@synthesize delegate;
@synthesize parentCodeBlock;
@synthesize valueCodeBlock;

- (void)viewDidLoad
{
    [super viewDidLoad];
    inputCellView = [PrimativeTypeUtility constructDefaultView:valueCodeBlock.ReturnType delegate:varDel value:valueCodeBlock];
    if(inputCellView)
        listSizeModifier = 1;
    availableCodeBlocks = [parentCodeBlock getAvailableParameters:valueCodeBlock.ReturnType];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [availableCodeBlocks count] + listSizeModifier;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0 && inputCellView){
        ValueInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        cell.delegate = self;
        varDel = [[VariableAssignmentDelegate alloc] init:valueCodeBlock];
        [cell setContent:[PrimativeTypeUtility constructDefaultView:valueCodeBlock.ReturnType delegate:varDel value:valueCodeBlock] indexPath:indexPath];
        return cell;
    } else {
        id<CodeBlock> codeBlock = [availableCodeBlocks objectAtIndex:indexPath.row-listSizeModifier];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = [codeBlock generateCode];
    
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && inputCellView)
        return 137;
    else
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && inputCellView)
        return;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id<CodeBlock> newParam = [availableCodeBlocks objectAtIndex:indexPath.row-listSizeModifier];
    VariableCodeBlock *varRef = [parentCodeBlock getParameterReferenceBlock:parentCodeBlock.ReturnType];
   
    if(valueCodeBlock.ReturnType == PARAMETER_RETURN && newParam.ReturnType != parentCodeBlock.ReturnType
       && varRef && varRef.ReferenceCount > 0){
        newParamBlock = newParam;
        NSString *message = [NSString stringWithFormat:@"Changing the block's type will unlink %d blocks currently using it. Do you wish to continue?", varRef.ReferenceCount];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Remove References?"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"YES"
                                                  otherButtonTitles:@"NO", nil];
        
        [alertView show];
    } else {
        if(delegate)
            [delegate didSelectValue:newParam previousCodeBlock:valueCodeBlock];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //Yes was Pressed
            if(newParamBlock) {
                if(delegate)
                    [delegate didSelectValue:newParamBlock previousCodeBlock:valueCodeBlock];
            }
            newParamBlock = nil;
            break;
        case 1:
            //No was Pressed
            [self dismissModalViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

-(void)submitClicked:(NSIndexPath *)index
{
    if(varDel)
        if(delegate)
            [delegate didSelectValue:varDel.value previousCodeBlock:valueCodeBlock];
}

@end
