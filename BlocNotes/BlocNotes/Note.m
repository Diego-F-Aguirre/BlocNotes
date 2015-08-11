//
//  Note.m
//  BlocNotes
//
//  Created by Diego Aguirre on 8/10/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "Note.h"
#import "CoreDataStack.h"


@implementation Note

@dynamic title;
@dynamic body;
@dynamic date;

+ (Note *)createNoteWithTitle:(NSString *)title body:(NSString *)body date:(NSDate *)date
{
    Note *newNote = [self createNoteWithTitle:title body:body];
    [newNote setValue:date forKey:@"date"];
    return newNote;
}

+ (Note *)createNoteWithTitle:(NSString *)title body:(NSString *)body
{
    
    Note *newNote = [self createNote];
    
    [newNote setValue:title forKey:@"title"];
    [newNote setValue:body forKey:@"body"];
    
    return newNote;
}

+ (Note *)createNote
{
    NSManagedObjectContext *context = [[CoreDataStack defaultStack] managedObjectContext];
    Note *note = (Note *) [[NSManagedObject alloc] initWithEntity:[self entityDescription] insertIntoManagedObjectContext:context];
    
    [note setValue:@"" forKey:@"title"];
    [note setValue:@"" forKey:@"body"];
    [note setValue:[NSDate date] forKey:@"date"];
    
    return note;
}

+ (NSEntityDescription *)entityDescription
{
    NSManagedObjectContext *context = [[CoreDataStack defaultStack] managedObjectContext];
    return [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
}

- (void)save
{
    NSError *error;
   [[[CoreDataStack defaultStack] managedObjectContext] save:&error];
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
    }
}

@end
