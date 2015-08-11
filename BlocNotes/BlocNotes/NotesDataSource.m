//
//  NotesDataSource.m
//  BlocNotes
//
//  Created by Diego Aguirre on 7/22/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "NotesDataSource.h"
#import "CoreDataStack.h"

@implementation NotesDataSource

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSManagedObjectContext *context = [[CoreDataStack defaultStack] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Note" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:40];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:context sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    
    return _fetchedResultsController;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSLog(@"%lu",(unsigned long)self.notes.count);
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Note *note = self.notes[indexPath.row];
    cell.textLabel.text = note.title;
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:note.date
                                                               dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Note *note = self.notes[indexPath.row];
        [[[CoreDataStack defaultStack] managedObjectContext] deleteObject:note];
    }
}

- (NSArray *)notes
{
    if (self.searchRequest)
    {
        NSError *error;
        NSArray *results = [[[CoreDataStack defaultStack] managedObjectContext] executeFetchRequest:self.searchRequest error:&error];
        NSLog(@"%@", error);
        return results;
    }
    else
    {
        return [self.fetchedResultsController fetchedObjects];
    }
}



@end
