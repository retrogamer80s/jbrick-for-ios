//
//  PropertyViewController.m
//  jbrick-for-ios
//
//  Created by Student on 10/12/12.
//
//

#import "PropertyViewController.h"
#import "CodeBlock.h"
#import "PrimativeTypeUtility.h"

@interface PropertyViewController ()

@end

@implementation PropertyViewController
@synthesize splitViewController = _splitViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        variables = [NSArray array];
        varDelegates = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [variables count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CodeBlock * valueCodeBlock = [[codeBlock getPropertyVariables] objectAtIndex:indexPath.row];
    
    if(valueCodeBlock.ReturnType != PARAMETER_NAME){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if(valueCodeBlock){
            cell.textLabel.text = [varNames objectAtIndex:indexPath.row];
            NSString *detail = [valueCodeBlock generateCode];
            cell.detailTextLabel.text = detail;
        }
        return cell;
    } else {
        ValueInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"valueCell"];
        cell.delegate = self;
        VariableAssignmentDelegate *varDel = [self getVarDelegate:valueCodeBlock index:indexPath];
        [cell setContent:[PrimativeTypeUtility constructDefaultView:valueCodeBlock.ReturnType delegate:varDel value:valueCodeBlock] indexPath:indexPath];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CodeBlock * valueCodeBlock = [[codeBlock getPropertyVariables] objectAtIndex:indexPath.row];
    if(valueCodeBlock.ReturnType == PARAMETER_NAME)
        return 137;
    else
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (VariableAssignmentDelegate *)getVarDelegate:(CodeBlock *)valueCodeBlock index:(NSIndexPath *)index
{
    if(![varDelegates objectForKey:index]){
        VariableAssignmentDelegate *varDel = [[VariableAssignmentDelegate alloc] init:valueCodeBlock];
        [varDelegates setObject:varDel forKey:index];
    }
    
    return [varDelegates objectForKey:index];
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CodeBlock * valueCodeBlock = [[codeBlock getPropertyVariables]  objectAtIndex:indexPath.row];
    
    if(valueCodeBlock.ReturnType != PARAMETER_NAME){
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        valuePicker = [sb instantiateViewControllerWithIdentifier:@"ValuePickerController"];
        valuePicker.parentCodeBlock = codeBlock;
        valuePicker.delegate = self;
        valuePicker.contentSizeForViewInPopover = self.view.frame.size;
        valuePicker.valueCodeBlock = valueCodeBlock;
        
        popoverController = [[UIPopoverControllerLandscape alloc] initWithContentViewController:valuePicker];
        
        NSInteger width = self.tableView.frame.size.width;
        NSInteger yPos = 0;
        for(int i=0; i < indexPath.row; i++)
            yPos += [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section]];
        NSInteger height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        CGRect cellFrame = CGRectMake(0, yPos, width, height);
        
        [popoverController presentPopoverFromRect:cellFrame inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (BOOL)isOpen
{
    return ![_splitViewController isShowingMaster];
}

-(void)setPropertyContent:(id<ViewableCodeBlock>) codeBlockParam
{
    codeBlock = codeBlockParam;
    if(codeBlock) {
        variables = [codeBlockParam getPropertyVariables];
        varNames = [codeBlockParam getPropertyDisplayNames];
    }
    else
        variables = [NSArray array];
    varDelegates = [NSMutableDictionary dictionary];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)closePanel:(void (^)(BOOL finished))completion
{
    [_splitViewController showMaster:self];
}

-(void)openPanel:(void (^)(BOOL finished))completion
{
    [_splitViewController hideMaster:self];
}

- (IBAction)ClosePressed:(id)sender {
    [self closePanel:nil];
}

- (void)didSelectValue:(CodeBlock *)newCodeBlock previousCodeBlock:(CodeBlock *)prevCodeBlock{
    if(newCodeBlock){
        [codeBlock replaceParameter:prevCodeBlock newParameter:newCodeBlock];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [popoverController dismissPopoverAnimated:YES];
    
}

- (void)submitClicked:(NSIndexPath *)index
{
    CodeBlock * valueCodeBlock = [[codeBlock getPropertyVariables]  objectAtIndex:index.row];
    VariableAssignmentDelegate *varDel = [self getVarDelegate:valueCodeBlock index:index];
    
    if(varDel.value){
        [codeBlock replaceParameter:valueCodeBlock newParameter:varDel.value];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:YES];
    }

}


@end
