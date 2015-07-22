//
//  Note.h
//  BlocNotes
//
//  Created by Diego Aguirre on 7/21/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <Realm/Realm.h>

@interface Note : RLMObject

@property NSString *title;
@property NSString *body;
@property NSString *search;
@property NSTimeInterval date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Note>
RLM_ARRAY_TYPE(Note)
