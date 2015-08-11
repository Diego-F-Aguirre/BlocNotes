//
//  EntryListViewController.h
//  BlocNotes
//
//  Created by Diego Aguirre on 7/21/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

//Add UISearchResultsUpdating protocol to update with new user info
@interface EntryListViewController : UITableViewController <UISearchResultsUpdating, UISearchBarDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
