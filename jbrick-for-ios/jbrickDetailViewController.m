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

@interface jbrickDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@property (weak, nonatomic) IBOutlet UITextView *src;
@property (weak, nonatomic) IBOutlet UITextField *filename;
- (IBAction)Upload:(id)sender;
@end

@implementation jbrickDetailViewController
@synthesize src = _src;
@synthesize filename = _filename;

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize submitButton = _submitButton;
@synthesize propertyPane = _propertyPane;
@synthesize programPane = _programPane;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize splitViewController = _splitViewController;

#pragma mark - Managing the detail item
float firstX;
float firstY;

- (IBAction)Upload:(id)sender {
    MethodDeclorationBlock *main = [MethodDeclorationBlock getMainBlock];
    NSLog([main generateCode]);
}

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
    
    MethodDeclorationBlock *main = [MethodDeclorationBlock getMainBlock];
    main.BlockColor = [UIColor purpleColor].CGColor;
    UIBlock *mainBlock = [[UIBlock alloc] init:self codeBlock:main];
    [self.programPane addSubview:mainBlock];
    
    UIImageView *trashCan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Trash Can.png"]];
    trashCan.frame = CGRectMake(615, 580, 100, 140);
    [self.view addSubview:trashCan];
    self.programPane.TrashCan = trashCan;
    
}

- (void)viewDidUnload
{
    [self setSrc:nil];
    [self setFilename:nil];
    [self setSubmitButton:nil]; 
    [self setPropertyPane:nil];
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
    [block removeFromSuperview];
    block.center = [self.programPane convertPoint:block.center fromView:_splitViewController.view];
    [self.programPane addSubview:block];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}
@end
