//
//  SearchResultsTableViewController.h
//  BlocNotes
//
//  Created by Diego Aguirre on 7/22/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "NotesDataSource.h"

@interface SearchResultsTableViewController : UITableViewController

@property (strong, nonatomic) NotesDataSource *dataSource;

@end
