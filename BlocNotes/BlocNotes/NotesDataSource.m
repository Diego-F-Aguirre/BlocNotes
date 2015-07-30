//
//  NotesDataSource.m
//  BlocNotes
//
//  Created by Diego Aguirre on 7/22/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "NotesDataSource.h"



@implementation NotesDataSource

- (NSInteger) dataCount {
    return self.notes.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSLog(@"%lu",(unsigned long)self.notes.count);
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Note *note = [self.notes objectAtIndex:indexPath.row];
    cell.textLabel.text = note.title;
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:note.date
                                                               dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        self.array = [Note allObjects];
        RLMRealm *realm = RLMRealm.defaultRealm;
        [realm beginWriteTransaction];
        NSLog(@"%@",self.array[indexPath.row]);
        [realm deleteObject:self.array[indexPath.row]];
        [realm commitWriteTransaction];
        
    }
}

@end
