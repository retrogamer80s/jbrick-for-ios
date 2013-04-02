//
//  jbrickNavViewController.m
//  jbrick-for-ios
//
//  Created by Student on 3/19/13.
//
//

#import "jbrickNavViewController.h"
#import "SaveFileList.h"
#import "RobotDataSource.h"
#import "Settings.h"
#import "CodeBlock.h"
#import "UIBlock.h"
#import "AFHTTPClient.h"

@implementation jbrickNavViewController

@synthesize codeBlockController;
@synthesize mainMenuController = mmController;
@synthesize detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)setMainMenuController:(UITableViewController *)mainMenuController{
    mmController = mainMenuController;
    mmController.title = @"Main Menu";
    [mmController.tableView setDelegate:self];
    [self pushViewController:mmController animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pressedPrograms {
    UITableViewController *table = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    SaveFileList *saveFileList = [[SaveFileList alloc] init:detailViewController tableView:table.tableView];
    currentDataSource = saveFileList;// The datasource object needs to be saved to a local variable
                                    // because otherwise arc will delete it after assignment... stupid!
    table.tableView.dataSource = currentDataSource;
    table.tableView.delegate = currentDataSource;
    table.tableView.allowsSelectionDuringEditing = YES;
    table.editButtonItem.target = currentDataSource;
    table.editButtonItem.action = @selector(setEditingMode);
    
    
    [self pushViewController:table animated:YES];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:saveFileList action:@selector(addProgram)];
    NSArray *barButtons = [NSArray arrayWithObjects:table.editButtonItem, addButton, nil];
    table.navigationItem.rightBarButtonItems = barButtons;
    
}

- (void) pressedRobots {
    UITableViewController *table = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    currentDataSource = [[RobotDataSource alloc] init:table.tableView navController:self]; // The datasource object needs to be saved to a local variable
                                                                        // because otherwise arc will delete it after assignment... stupid!
    table.tableView.dataSource = currentDataSource;
    table.tableView.delegate = currentDataSource;
    
    [self pushViewController:table animated:YES];
}

- (void) pressedCodeBlocks {
    [self pushViewController:codeBlockController animated:YES];
}

- (void) pressedSave {
    [self.detailViewController saveProgram:[Settings settings].CurrentProgram];
}

- (void) pressedUpload {
    CodeBlock *main = [detailViewController.programPane getRootBlock].CodeBlock;
    NSLog(@"Code:\n%@",[main generateCode]);
    
    NSURL *url = [NSURL URLWithString:@"http://media-server.cjpresler.com/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    httpClient.stringEncoding = NSUTF16StringEncoding;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [main generateCode], @"src",
                            [Settings settings].CurrentProgram, @"filename",
                            nil];
    [httpClient postPath:[NSString stringWithFormat:@"rest/Devices/%@/compile", [Settings settings].RobotID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

- (void) pressedRun {
    NSURL *url = [NSURL URLWithString:@"http://media-server.cjpresler.com/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Settings settings].CurrentProgram, @"program",
                            nil];
    [httpClient getPath:[NSString stringWithFormat:@"rest/Devices/%@/RunProgram", [Settings settings].RobotID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self pressedPrograms];
            break;
        case 1:
            [self pressedRobots];
            break;
        case 2:
            [self pressedCodeBlocks];
            break;
        case 4:
            [self pressedSave];
            break;
        case 5:
            [self pressedUpload];
            break;
        case 6:
            [self pressedRun];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
