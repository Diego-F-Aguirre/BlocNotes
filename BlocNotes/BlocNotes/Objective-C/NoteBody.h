//
//  NoteBody.h
//  BlocNotes
//
//  Created by Diego Aguirre on 7/27/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <Realm/Realm.h>

@interface NoteBody : RLMObject
<# Add properties here to define the model #>
@end

// This protocol enables typed collections. i.e.:
// RLMArray<NoteBody>
RLM_ARRAY_TYPE(NoteBody)
