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
#import "VariableAssignmentBlock.h"
#import "VariableMathBlock.h"
#import "WhileLoopCodeBlock.h"
#import "LogicalOperatorCodeBlock.h"
#import "ElseCodeBlock.h"
#import "KGNoise.h"

@interface jbrickMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation jbrickMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize splitViewController = _splitViewController;

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
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = .15;
    [self.tableView addGestureRecognizer:longPress];
    
    methodBlocks = [[NSMutableDictionary alloc] init];
    reuseCells = [[NSMutableArray alloc] init];
    
    WhileLoopCodeBlock *ifBlock = [[WhileLoopCodeBlock alloc] init:IF];
    WhileLoopCodeBlock *whileLoop = [[WhileLoopCodeBlock alloc] init:WHILE];
    ElseCodeBlock *elseBlock = [[ElseCodeBlock alloc] init];
    LogicalOperatorCodeBlock *logicOp = [[LogicalOperatorCodeBlock alloc] init];
    MethodCallCodeBlock *onFWD = [[MethodCallCodeBlock alloc] init:@"OnFwd"
                                        description:@"Sets the specified Motor to move forward with the given Power"
                                        parameterTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:MOTOR],[NSNumber numberWithInt:MOTOR_POWER], nil]
                                        parameterNames:[NSArray arrayWithObjects:@"Motor", @"Motor Power", nil]
                                        returnType:VOID];
    MethodCallCodeBlock *onRev = [[MethodCallCodeBlock alloc] init:@"OnRev"
                                        description:@"Sets the specified Motor to move backwards with the given Power"
                                        parameterTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:MOTOR],[NSNumber numberWithInt:MOTOR_POWER], nil]
                                        parameterNames:[NSArray arrayWithObjects:@"Motor", @"Motor Power", nil]
                                        returnType:VOID];
    MethodCallCodeBlock *playTone = [[MethodCallCodeBlock alloc] init:@"PlayTone"
                                        description:@"Plays a given tone for a given duration"
                                        parameterTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:INTEGER],[NSNumber numberWithInt:INTEGER], nil]
                                        parameterNames:[NSArray arrayWithObjects:@"Frequency (Hz)", @"Duration (ms)", nil]
                                        returnType:VOID];
    MethodCallCodeBlock *wait = [[MethodCallCodeBlock alloc] init:@"Wait"
                                        description:@"Stops the next block from running for a given number of milliseconds"
                                        parameterTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:INTEGER], nil]
                                        parameterNames:[NSArray arrayWithObjects:@"Time (ms)", nil]
                                        returnType:VOID];
    MethodCallCodeBlock *stopMotor = [[MethodCallCodeBlock alloc] init:@"Off"
                                        description:@"Stops the specified motor by applying a brake"
                                        parameterTypes:[NSArray arrayWithObject:[NSNumber numberWithInt:MOTOR]]
                                        parameterNames:[NSArray arrayWithObjects:@"Motor", nil]
                                        returnType:VOID];
    MethodCallCodeBlock *setSensor = [[MethodCallCodeBlock alloc] init:@"SetSensorType"
                                        description:@""
                                        parameterTypes:[NSArray arrayWithObjects:[NSNumber numberWithInt:PORT],[NSNumber numberWithInt:SENSOR_TYPE], nil]
                                        parameterNames:[NSArray arrayWithObjects:@"Port", @"Sensor Type", nil]
                                        returnType:VOID];
    MethodCallCodeBlock *sensorBoolean = [[MethodCallCodeBlock alloc] init:@"SensorBoolean"
                                        description:@""
                                        parameterTypes:[NSArray arrayWithObject:[NSNumber numberWithInt:PORT]]
                                        parameterNames:[NSArray arrayWithObjects:@"Port", nil]
                                        returnType:BOOLEAN];
    VariableDeclorationBlock *variable = [[VariableDeclorationBlock alloc] init:@"Variable" type:VOID];
    ValueCodeBlock *value = [[ValueCodeBlock alloc] init:VOID value:nil displayName:@"Value"];
    VariableAssignmentBlock *varAssign = [[VariableAssignmentBlock alloc] init];
    VariableMathBlock *varMath = [[VariableMathBlock alloc] init];

    UIColor *red = [UIColor colorWithRed:234.0/255 green:55.0/255 blue:19.0/255 alpha:1];
    UIColor *blue = [UIColor colorWithRed:19.0/255 green:91.0/255 blue:234.0/255 alpha:1];
    UIColor *green = [UIColor colorWithRed:19.0/255 green:234.0/255 blue:55.0/255 alpha:1];
    
    ifBlock.BlockColor = red;
    whileLoop.BlockColor = red;
    elseBlock.BlockColor = red;
    logicOp.BlockColor = red;
    onFWD.BlockColor = blue;
    onRev.BlockColor = blue;
    playTone.BlockColor = blue;
    wait.BlockColor = red;
    stopMotor.BlockColor = blue;
    setSensor.BlockColor = blue;
    sensorBoolean.BlockColor = blue;
    variable.BlockColor = green;
    value.BlockColor = green;
    varAssign.BlockColor = [UIColor orangeColor];
    varMath.BlockColor = [UIColor orangeColor];
    
    ifBlock.Icon = [UIImage imageNamed:@"if-else.png"];
    whileLoop.Icon = [UIImage imageNamed:@"Loop_icon.png"];
    elseBlock.Icon = [UIImage imageNamed:@"if-else.png"];
    logicOp.Icon = [UIImage imageNamed:@"Math.png"];
    onFWD.Icon = [UIImage imageNamed:@"forward_wheel_icon.png"];
    onRev.Icon = [UIImage imageNamed:@"backward_wheel_icon.png"];
    playTone.Icon = [UIImage imageNamed:@"speaker.png"];
    wait.Icon = [UIImage imageNamed:@"Wait_icon.png"];
    stopMotor.Icon = [UIImage imageNamed:@"wheel_icon.png"];
    setSensor.Icon = [UIImage imageNamed:@"Gear.png"];
    sensorBoolean.Icon = [UIImage imageNamed:@"Gear.png"];
    variable.Icon = [UIImage imageNamed:@"Variable.png"];
    value.Icon = [UIImage imageNamed:@"value.png"];
    varAssign.Icon = [UIImage imageNamed:@"Equals_icon.png"];
    varMath.Icon = [UIImage imageNamed:@"Math.png"];
    
    NSArray *systemMethods = [NSArray arrayWithObjects:onFWD, onRev, stopMotor, playTone, wait, nil];
    NSArray *logicMethods = [NSArray arrayWithObjects:whileLoop, ifBlock, elseBlock, logicOp, nil];
    NSArray *inputMethods = [NSArray arrayWithObjects:setSensor, sensorBoolean, nil];
    NSArray *varMathMethods = [NSArray arrayWithObjects: variable, value, varAssign, nil];
    //NSMutableArray *customMethods = [NSMutableArray arrayWithObjects:nil];
    
    [methodBlocks setObject:systemMethods forKey:@"System"];
    [methodBlocks setObject:logicMethods forKey:@"Logic"];
    [methodBlocks setObject:inputMethods forKey:@"Input"];
    [methodBlocks setObject:varMathMethods forKey:@"Variable"];
    
    for(int i=0; i < methodBlocks.count; i++)
        [reuseCells addObject:[NSMutableArray array]];
     
    selectedIndex = [NSIndexPath indexPathForRow:-1 inSection:-1];
}

- (void)viewDidUnload
{
    [self setParametersLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)insertNewObject:(id)sender
{
    /* Not allowing adding custom blocks yet
    [[methodBlocks objectForKey:@"Custom"] insertObject:@"Method Name" atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     */
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
        
        CodeBlock<ViewableCodeBlock> *codeBlock = [[[methodBlocks allValues] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.detailViewController.propertyPane closePanel:nil];
        
        // create item to be dragged
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
    return [[reuseCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *sectionCells = [reuseCells objectAtIndex:indexPath.section];
    if(! (sectionCells.count > indexPath.row && [sectionCells objectAtIndex:indexPath.row])){
        MethodTabelCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_Expanded"];
        
        NSArray *methods = [methodBlocks objectForKey:[[methodBlocks allKeys] objectAtIndex:indexPath.section]];
        CodeBlock<ViewableCodeBlock> *codeBlock = [methods objectAtIndex:indexPath.row];
        [cell.customLabel setText:[codeBlock getDisplayName]];
        [cell.DescriptionLabel setText:codeBlock.Description];
        [cell.ParametesLabel setText:[self buildParameterString:codeBlock]];
        [sectionCells insertObject:cell atIndex:indexPath.row];
    }
    
    MethodTabelCell *cell = [[reuseCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell.Height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if([[methodBlocks allKeys] objectAtIndex:indexPath.section] == @"Custom")
        return YES;
    return NO;
}

- (NSString *) buildParameterString:(id<ViewableCodeBlock>)codeBlock{
    NSMutableString *statement = [NSMutableString string];
    NSArray *params = [codeBlock getPropertyVariables];
    for (int i=0; i<params.count; i++) {
        NSString *type = [PrimativeTypeUtility primativeToName:((CodeBlock*)[params objectAtIndex:i]).ReturnType];
        NSString *name = [[codeBlock getPropertyDisplayNames] objectAtIndex:i];
        NSString *param = [NSString stringWithFormat:@"%@ - %@\n", name, type];
        [statement appendString:param];
    }
    
    NSString *type = [PrimativeTypeUtility primativeToName:((CodeBlock *)codeBlock).ReturnType];
    NSString *param = [NSString stringWithFormat:@"%@ - %@\n", @"Return", type];
    [statement appendString:param];
    
    return statement;
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
    [tableView beginUpdates];
    if(selectedIndex.row == indexPath.row && selectedIndex.section == indexPath.section)
    {
        MethodTabelCell *cell = (MethodTabelCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.Expanded = false;
        selectedIndex = [NSIndexPath indexPathForRow:-1 inSection:-1];
        [tableView endUpdates];
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex.row >= 0)
    {
        NSIndexPath *previousPath = selectedIndex;
        MethodTabelCell *cell = (MethodTabelCell *)[tableView cellForRowAtIndexPath:previousPath];
        cell.Expanded = false;
    }
    
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath;
    MethodTabelCell *cell = (MethodTabelCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.Expanded = true;
    [tableView endUpdates];
    
}

- (NSString *)convertToKey:(NSInteger)section {
    return [[methodBlocks allKeys] objectAtIndex:section];
}

@end
