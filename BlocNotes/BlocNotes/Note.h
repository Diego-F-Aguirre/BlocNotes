//
//  Note.h
//  BlocNotes
//
//  Created by Diego Aguirre on 8/10/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * date;

+ (Note *)createNoteWithTitle:(NSString *)title body:(NSString *)body;
- (void)save;

@end
