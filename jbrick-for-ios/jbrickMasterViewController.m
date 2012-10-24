//
//  jbrickMasterViewController.m
//  jbrick-for-ios
//
//  Created by Student on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "jbrickMasterViewController.h"
#import "jbrickDetailViewController.h"
#import "MGSplitViewController.h"
#import "MethodCallCodeBlock.h"
#import "MethodDeclorationBlock.h"
#import "VariableDeclorationBlock.h"
#import "KGNoise.h"

@interface jbrickMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation jbrickMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize splitViewController = _splitViewController;

bool inDrag = NO;
UIBlock *draggedView = nil;
NSIndexPath *selectedIndex = nil;
NSMutableDictionary *methodBlocks;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (jbrickDetailViewController *)[[_splitViewController.viewControllers lastObject] topViewController];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [longPress setMinimumPressDuration:0.15];
    [self.tableView addGestureRecognizer:longPress];    
    
    methodBlocks = [[NSMutableDictionary alloc] init];
    
    MethodDeclorationBlock *ifBlock = [[MethodDeclorationBlock alloc] init:@"If" parameterVariables:[[NSMutableArray alloc]init] returnType:VOID];
    MethodCallCodeBlock *onFWD = [[MethodCallCodeBlock alloc] init:@"OnFwd" parameterTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:MOTOR],[NSNumber numberWithInt:MOTOR_POWER],[NSNumber numberWithInt:INTEGER], nil] returnType:VOID];
    MethodCallCodeBlock *wait = [[MethodCallCodeBlock alloc] init:@"Wait" parameterTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:INTEGER], nil] returnType:VOID];
    MethodCallCodeBlock *stopMotor = [[MethodCallCodeBlock alloc] init:@"Off" parameterTypes:[NSArray arrayWithObject:[NSNumber numberWithInt:MOTOR]] returnType:VOID];
    VariableDeclorationBlock *variable = [[VariableDeclorationBlock alloc] init:@"MOTOR_POWER" type:MOTOR_POWER];

    ifBlock.BlockColor = [UIColor yellowColor].CGColor;
    onFWD.BlockColor = [UIColor greenColor].CGColor;
    wait.BlockColor = [UIColor blueColor].CGColor;
    stopMotor.BlockColor = [UIColor redColor].CGColor;
    variable.BlockColor = [UIColor orangeColor].CGColor;
    
    ifBlock.Icon = [UIImage imageNamed:@"Loop_icon.png"];
    onFWD.Icon = [UIImage imageNamed:@"forward_wheel_icon.png"];
    wait.Icon = [UIImage imageNamed:@"Wait_icon.png"];
    stopMotor.Icon = [UIImage imageNamed:@"wheel_icon.png"];
    variable.Icon = [UIImage imageNamed:@"Variable.png"];
    
    NSArray *motorMethods = [NSArray arrayWithObjects:onFWD, stopMotor, nil];
    NSArray *logicMethods = [NSArray arrayWithObjects:wait, ifBlock, variable, nil];
    NSMutableArray *customMethods = [NSMutableArray arrayWithObjects:nil];
    
    [methodBlocks setObject:motorMethods forKey:@"Motor Blocks"];
    [methodBlocks setObject:logicMethods forKey:@"Logic Blocks"];
    [methodBlocks setObject:customMethods forKey:@"Custom"];
     
    selectedIndex = [NSIndexPath indexPathForRow:-1 inSection:-1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)insertNewObject:(id)sender
{
    [[methodBlocks objectForKey:@"Custom"] insertObject:@"Method Name" atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)longPress:(UIGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        // figure out which item in the table was selected
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]];
        if (!indexPath)
        {
            inDrag = NO;
            return;
        }
        
        inDrag = YES;
        
        id<ViewableCodeBlock> codeBlock = [[[methodBlocks allValues] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.detailViewController.propertyPane closePanel:nil];
        
        // create item to be dragged, in this example, just a simple UILabel
        UIView *splitView = _splitViewController.view;
        CGPoint point = [sender locationInView:splitView];
        
        draggedView = [[UIBlock alloc] init:self.detailViewController codeBlock:[codeBlock getPrototype]];
        draggedView.center = CGPointMake(point.x+(draggedView.frame.size.width/2)-20, point.y +(draggedView.frame.size.height/2)-20);

        // now add the item to the view
        [splitView addSubview:draggedView];
    }
    else if (sender.state == UIGestureRecognizerStateChanged && inDrag) 
    {
        // we dragged it, so let's update the coordinates of the dragged view
        
        UIView *splitView = _splitViewController.view;
        CGPoint point = [sender locationInView:splitView];
        
        CGPoint blockLoc = [self.detailViewController.programPane convertPoint:draggedView.frame.origin fromView:_splitViewController.view];
        CGSize contSize = self.detailViewController.programPane.contentSize;
        
        [draggedView panToPoint:point scrollToRect:CGRectMake(blockLoc.x > contSize.width ? 0 : blockLoc.x, blockLoc.y, 100, 100)];
    }
    else if (sender.state == UIGestureRecognizerStateEnded && inDrag)
    {
        [self.detailViewController placeBlock:draggedView];
        [draggedView snapToGrid];
    }
}

#pragma mark - Table View

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[methodBlocks allKeys] objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [methodBlocks count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[methodBlocks objectForKey:[[methodBlocks allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MethodTabelCell *cell;
    if (selectedIndex.row == indexPath.row && selectedIndex.section == indexPath.section)
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_Expanded"];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_Normal"];
    NSArray *methods = [methodBlocks objectForKey:[[methodBlocks allKeys] objectAtIndex:indexPath.section]];
    id<ViewableCodeBlock> codeBlock = [methods objectAtIndex:indexPath.row];
    [cell.customLabel setText:[codeBlock getDisplayName]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If this is the selected index we need to return the height of the cell
    //in relation to the label height otherwise we just return the minimum label height with padding
    if(selectedIndex.row == indexPath.row && selectedIndex.section == indexPath.section)
    {
        return 153;
    }
    else {
        return 57;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if([[methodBlocks allKeys] objectAtIndex:indexPath.section] == @"Custom")
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[methodBlocks objectForKey:[self convertToKey:indexPath.section]] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if(selectedIndex.row == indexPath.row && selectedIndex.section == indexPath.section){
            selectedIndex = [NSIndexPath indexPathForRow:-1 inSection:-1];
            if([tableView numberOfRowsInSection:indexPath.section]-1 > indexPath.row)
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *object = [_objects objectAtIndex:indexPath.row];
    self.detailViewController.detailItem = object;
    
    if(selectedIndex.row == indexPath.row && selectedIndex.section == indexPath.section)
    {
        selectedIndex = [NSIndexPath indexPathForRow:-1 inSection:-1];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex.row >= 0)
    {
        NSIndexPath *previousPath = selectedIndex;
        selectedIndex = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSString *)convertToKey:(NSInteger)section {
    return [[methodBlocks allKeys] objectAtIndex:section];
}

@end
