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
    NSLog(@"Code:\n%@",[main generateCode]);
    
    // Testing out serializtion
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savePath = [rootPath stringByAppendingPathComponent:@"save.sav"];
    [NSKeyedArchiver archiveRootObject:[self.programPane getRootBlock] toFile:savePath];
    // Done testing here
    
    NSURL *url = [NSURL URLWithString:@"http://media-server.cjpresler.com/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    httpClient.stringEncoding = NSUTF16StringEncoding;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [main generateCode], @"src",
                            @"Test", @"filename",
                            nil];
    [httpClient postPath:[NSString stringWithFormat:@"rest/Devices/%@/compile", robotID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

- (IBAction)RunProgram:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://media-server.cjpresler.com/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"Test", @"program",
                            nil];
    [httpClient getPath:[NSString stringWithFormat:@"rest/Devices/%@/RunProgram", robotID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];

}
- (IBAction)SelectRobot:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://media-server.cjpresler.com/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];

    [httpClient  getPath:@"rest/Devices" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSString *responseStr = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
        
        id jsonRobots = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONWritingPrettyPrinted error:nil];
        NSArray *robots =  [NSArray arrayWithArray:jsonRobots];
        
        NSMutableArray *names = [NSMutableArray array];
        NSMutableArray *ids = [NSMutableArray array];
        for (NSDictionary *robotDict in robots) {
            [names addObject:[robotDict valueForKey:@"Name"]];
            [ids addObject:[robotDict valueForKey:@"ID"]];
        }
        
        picker = [[RobotPickerController alloc] init:ids names:names selectedID:robotID delegate:self];
        popoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
        
        
        [popoverController presentPopoverFromRect:_SelectRobotButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

- (void)didSelectRobot:(NSString *)newRobotID name:(NSString *)robotName{
    robotID = newRobotID;
    
    [popoverController dismissPopoverAnimated:YES];
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
    
    // Testing out serializtion
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savePath = [rootPath stringByAppendingPathComponent:@"save.sav"];
    if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
        UIBlock *block = [NSKeyedUnarchiver unarchiveObjectWithFile:savePath];
        [block initializeControllers:self.programPane Controller:self];
        [self.programPane fitToContent];
    } else {
        MethodDeclorationBlock *main = [MethodDeclorationBlock getMainBlock];
        UIBlock *mainBlock = [[UIBlock alloc] init:self codeBlock:main];
        [self.programPane addSubview:mainBlock];
    }
    
    // Done testing here
    
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
    [self setSelectRobotButton:nil];
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
