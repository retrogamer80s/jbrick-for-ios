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

@implementation jbrickNavViewController

@synthesize codeBlockController;
@synthesize mainMenuController = mmController;

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
    currentDataSource = [[SaveFileList alloc] init]; // The datasource object needs to be saved to a local variable
                                                     // because otherwise arc will delete it after assignment... stupid!
    table.tableView.dataSource = currentDataSource;
    
    [self pushViewController:table animated:YES];
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
        default:
            break;
    }
}

@end
