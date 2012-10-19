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
    id<CodeBlock> valueCodeBlock = [variables objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(valueCodeBlock){
        cell.textLabel.text = [PrimativeTypeUtility primativeToName:valueCodeBlock.ReturnType];
        NSString *detail = [valueCodeBlock generateCode];
        cell.detailTextLabel.text = detail;
    }
        
    return cell;
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
    id<CodeBlock> valueCodeBlock = [variables objectAtIndex:indexPath.row];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    valuePicker = [sb instantiateViewControllerWithIdentifier:@"ValuePickerController"];
    valuePicker.parentCodeBlock = codeBlock;
    valuePicker.delegate = self;
    valuePicker.contentSizeForViewInPopover = self.view.frame.size;
    valuePicker.valueCodeBlock = valueCodeBlock;
                             
    popoverController = [[UIPopoverController alloc] initWithContentViewController:valuePicker];
    
    [popoverController presentPopoverFromRect:[self tableView:self.tableView cellForRowAtIndexPath:indexPath].frame inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)isOpen
{
    return ![_splitViewController isShowingMaster];
}

-(void)setPropertyContent:(id<ViewableCodeBlock>) codeBlockParam
{
    codeBlock = codeBlockParam;
    //for(int i=0; i<[self.tableView numberOfRowsInSection:0]; i++)
        //[self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:NO];
    //[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:YES];
    variables = [codeBlockParam getPropertyVariables];
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

- (void)didSelectValue:(id<CodeBlock>)newCodeBlock previousCodeBlock:(id<CodeBlock>)prevCodeBlock{
    NSIndexPath *index = [NSIndexPath indexPathForItem:[variables indexOfObject:prevCodeBlock] inSection:0];
    [codeBlock replaceParameter:prevCodeBlock newParameter:newCodeBlock];
    [popoverController dismissPopoverAnimated:YES];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:YES];
}


@end
