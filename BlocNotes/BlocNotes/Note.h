//
//  Note.h
//  BlocNotes
//
//  Created by Diego Aguirre on 7/21/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <Realm/Realm.h>

//Created a new Realm Model Object called Note with the appropriate properties

@interface Note : RLMObject

@property NSString *title;
@property NSDate *date;
@property NSString *body;

-(instancetype) initWithTitle:(NSString *)title body:(NSString*)body;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Note>
RLM_ARRAY_TYPE(Note)
