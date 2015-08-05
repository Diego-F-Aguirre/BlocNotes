//
//  Note.m
//  BlocNotes
//
//  Created by Diego Aguirre on 7/21/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "Note.h"

@implementation Note

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

- (instancetype) init
{
    if ([super init])
    {
        self.title = @"";
        self.body = @"";
        self.date = [NSDate date];
    }
    return self;
}

-(instancetype) initWithTitle:(NSString *)title body:(NSString*)body
{
    if ([self init])
    {
        if (title)
        {
            self.title = title;
        }
        if (body)
        {
            self.body = body;
        }
       
    }
    return self;
}

@end
