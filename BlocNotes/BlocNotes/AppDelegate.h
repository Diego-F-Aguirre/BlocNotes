//
//  AppDelegate.h
//  BlocNotes
//
//  Created by Diego Aguirre on 7/21/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSFileManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)processiCloudFiles:(NSNotification *)notification;

@end

