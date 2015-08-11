//
//  AppDelegate.m
//  BlocNotes
//
//  Created by Diego Aguirre on 7/21/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "AppDelegate.h"
#import "Note.h"
#import "ICloudSyncHelper.h"

@interface AppDelegate ()

@property NSURL *iCloudRoot;
@property NSURL *iCloudDatabaseFileURL;
@property bool appDidEnterBackground;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)syncPendingNotes
{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.diegoa3d.BlocNotes"];
    NSArray *pendingNotes = [sharedDefaults objectForKey:@"notesPending"];
    for (NSDictionary *note in pendingNotes)
    {
        Note *newNote = [Note createNoteWithTitle:note[@"title"] body:note[@"body"] date:note[@"date"]];
        [newNote save];
    }
    [sharedDefaults setObject:@[] forKey:@"notesPending"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self syncPendingNotes];
}

#pragma mark - iCloud Methods

- (void)processiCloudFiles:(NSNotification *)notification {
    
    [[ICloudSyncHelper query] disableUpdates];
    
    NSDate *iCloudModificationDate = nil;
    NSArray *results = [ICloudSyncHelper query].results;
    NSFileManager *manager = [[NSFileManager alloc] init];
    manager.delegate = self;
    
    for (NSMetadataItem *result in results) {
        NSURL * fileURL = [result valueForAttribute:NSMetadataItemURLKey];
        iCloudModificationDate = [result valueForAttribute:NSMetadataItemFSContentChangeDateKey];
        NSNumber * aBool = nil;
        
        // Don't include hidden files
        [fileURL getResourceValue:&aBool forKey:NSURLIsHiddenKey error:nil];
        if (aBool && ![aBool boolValue]) {
            self.iCloudDatabaseFileURL = fileURL;
            break;
        }
    }
    
    if (!self.iCloudDatabaseFileURL)
    {
        [ICloudSyncHelper uploadFileWithURL:[ICloudSyncHelper realmDatabaseURL]];
    }
    else
    {
        NSError *error;
        [manager startDownloadingUbiquitousItemAtURL:self.iCloudDatabaseFileURL error:&error];
        NSLog(@"%@", error);
    }
    [RLMRealm setDefaultRealmPath:[ICloudSyncHelper iCloudDatabaseURL].path];
    [[NSUserDefaults standardUserDefaults] setObject:[ICloudSyncHelper iCloudDatabaseURL].path forKey:@"containerPath"];
    self.appDidEnterBackground = false;
}

- (void)initializeiCloudAccessWithCompletion:(void (^)(BOOL available)) completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.iCloudRoot = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        if (self.iCloudRoot != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"iCloud available at: %@", self.iCloudRoot);
                completion(TRUE);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"iCloud not available");
                completion(FALSE);
            });
        }
    });
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    if ([error code] == NSFileWriteFileExistsError)
        return YES;
    else
        return NO;
}

@end
