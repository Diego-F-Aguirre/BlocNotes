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
#import "EditEntryViewController.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface EntryListViewController ()

//A token is needed to save the data source as well as to be able to recall it

@property UISearchController *searchController;
@property NotesDataSource *dataSource;

@end

@implementation EntryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //instatiate the DataSource and set it to the tableView dataSource
    self.dataSource = [NotesDataSource new];
    self.tableView.dataSource = self.dataSource;
    self.dataSource.fetchedResultsController.delegate = self;
    
    //instatiate the token and add a notification block to reload data when it has been updated
    NSError *error;
    [self.dataSource.fetchedResultsController performFetch:&error];
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
    }
    
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"notesTableSearchResultsNavigationController"];
    //Create the search controler and set it to the UINavigationController and place it's position
    self.searchController = [[UISearchController alloc] initWithSearchResultsController: searchResultsController];
    ((SearchResultsTableViewController *)searchResultsController.topViewController).searchController = self.searchController;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Add iCloud observers
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storesWillChange) name:NSPersistentStoreCoordinatorStoresWillChangeNotification object:self.managedObjectContext.persistentStoreCoordinator];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storesDidChange) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:self.managedObjectContext.persistentStoreCoordinator];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeContent:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:self.managedObjectContext.persistentStoreCoordinator];
}

#pragma mark = iCloud Methods
- (void)storesWillChange{
    NSLog(@"/n/nStores Will change notification received/n/n");
    
    //Disable UI
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    //Save and reset our context
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
    } else {
        [self.managedObjectContext reset];
    }
}

- (void)storesDidChange{
    NSLog(@"/n/nStores Did change notification received/n/n");
    //enable UI
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    //update UI
    [self.tableView reloadData];
}

- (void)mergeContent:(NSNotification *)notification{
    NSLog(@"Merge content here");
    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

//After the token has been called it must be deallocated

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = self.searchController.searchBar.text;
    NSFetchRequest *fetchRequest = [self updateFilteredContentForSearchedText:searchString];
    if (self.searchController.searchResultsController)
    {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        vc.dataSource.searchRequest = fetchRequest;
        [vc.tableView reloadData];
    }

}
//Filter method to detect case sensitive words in both the title and the body of the note
- (NSFetchRequest *)updateFilteredContentForSearchedText:(NSString *)searchedText
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Note"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ OR body CONTAINS[c] %@", searchedText, searchedText];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"date" ascending:NO];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[sort]];
    return request;
}

//Identify editEntrySeque as the main destination so a cell/note can be modified when searched for
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editEntrySegue"])
    {
        EditEntryViewController *dest = (EditEntryViewController *)segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        dest.note = self.dataSource.notes[indexPath.row];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];}
////     else if (editingStyle == UITableViewCellEditingStyleInsert) {
////        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
////    }   
//}


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
