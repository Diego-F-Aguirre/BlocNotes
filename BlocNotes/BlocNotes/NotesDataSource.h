//
//  NotesDataSource.h
//  BlocNotes
//
//  Created by Diego Aguirre on 7/22/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Note.h"
#import "EntryListViewController.h"

//Created a new NSObject called NotesDataSource that serves as the main data source to be called throughout the app. 

@interface NotesDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchRequest *searchRequest;

-(NSArray *)notes;

@end
