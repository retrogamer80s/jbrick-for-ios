//
//  jbrickDetailViewController.m
//  jbrick-for-ios
//
//  Created by Student on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "jbrickDetailViewController.h"

#import "MethodCallCodeBlock.h"
#import "MethodDeclorationBlock.h"
#import "ValueCodeBlock.h"
#import "UIBlock.h"
#import "KGNoise.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "Settings.h"

@interface jbrickDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation jbrickDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize propertyPane = _propertyPane;
@synthesize programPane = _programPane;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize splitViewController = _splitViewController;

#pragma mark - Managing the detail item
float firstX;
float firstY;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOutsideBlock:)];
    [tapGesture setDelegate:self];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *sg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightReceived:)];
    sg.numberOfTouchesRequired = 2;
    sg.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:sg];
    
    sg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftReceived:)];
    sg.numberOfTouchesRequired = 2;
    sg.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:sg];
    
    UIImageView *trashCan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Trash Can.png"]];
    trashCan.frame = CGRectMake(615, 580, 100, 140);
    [self.view addSubview:trashCan];
    self.programPane.TrashCan = trashCan;
    
    [self loadNewProgram:[ Settings settings].CurrentProgram];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(UIBlock *) createNewProgram
{
    MethodDeclorationBlock *newMain = [MethodDeclorationBlock createNewMainBlock];
    UIBlock *newMainBlock = [[UIBlock alloc] init:self codeBlock:newMain];
    return newMainBlock;
}

-(void) saveProgram:(NSString *)name
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sav", name]];
    [NSKeyedArchiver archiveRootObject:[_programPane getRootBlock] toFile:savePath];
}

-(void) loadNewProgram:(NSString *)name
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sav", name]];
    if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
        UIBlock *block = [NSKeyedUnarchiver unarchiveObjectWithFile:savePath];
        [self.programPane loadProgram:block controller:self];
    } else {
        UIBlock *block = [self createNewProgram];
        [self.programPane loadProgram:block controller:self];
        [self saveProgram:name];
    }

}

- (void)viewDidUnload
{
    [self setPropertyPane:nil];
    [self setProgramPane:nil];
    [self setProgramName:nil];
    [self setProgramPane:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}

- (void)swipeRightReceived:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [_propertyPane closePanel:nil];
}

- (void)swipeLeftReceived:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [_propertyPane openPanel:nil];
}

- (void)tapOutsideBlock:(UITapGestureRecognizer *)gestureRecognizer
{
    [_propertyPane closePanel:nil];
}

- (void)placeBlock:(UIView *)block
{
    block.center = [self.programPane convertPoint:block.center fromView:block.superview];
    [block removeFromSuperview];
    [self.programPane addSubview:block];
    
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverControllerParam
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverControllerParam;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}
@end
