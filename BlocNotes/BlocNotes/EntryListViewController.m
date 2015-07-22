//
//  EntryListViewController.m
//  BlocNotes
//
//  Created by Diego Aguirre on 7/21/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "EntryListViewController.h"
#import "Note.h"
#import "SearchResultsTableViewController.h"
#import "NotesDataSource.h"

@interface EntryListViewController ()

//A token is needed to save the data source as well as to be able to recall it
@property RLMNotificationToken *token;
@property UISearchController *searchController;
@property NotesDataSource *dataSource;

@end

@implementation EntryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NotesDataSource new];
    self.tableView.dataSource = self.dataSource;
    
    self.token = [[RLMRealm defaultRealm] addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
        self.dataSource.notes = [[Note allObjects] sortedResultsUsingProperty:@"date" ascending:NO];
        [self.tableView reloadData];
    }];
    self.dataSource.notes = [[Note allObjects] sortedResultsUsingProperty:@"date" ascending:NO];
    
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"notesTableSearchResultsNavigationController"];
    
    //Programmatically created the search bar and placed it's position
    self.searchController = [[UISearchController alloc] initWithSearchResultsController: searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc
{
    [[RLMRealm defaultRealm] removeNotification:self.token];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
     NSString *searchString = self.searchController.searchBar.text;
    RLMResults *filteredNotes = [self updateFilteredContentForSearchedText:searchString];
    if (self.searchController.searchResultsController)
    {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        vc.dataSource.notes = filteredNotes;
        [vc.tableView reloadData];
    }

}

- (RLMResults *)updateFilteredContentForSearchedText:(NSString *)searchedText
{
    return [[Note objectsWhere:[NSString stringWithFormat:@"title CONTAINS[c] '%@' OR body CONTAINS[c] '%@'", searchedText, searchedText]] sortedResultsUsingProperty:@"date" ascending:NO];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end