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
@property NSString *body;
@property NSDate *date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Note>
RLM_ARRAY_TYPE(Note)
