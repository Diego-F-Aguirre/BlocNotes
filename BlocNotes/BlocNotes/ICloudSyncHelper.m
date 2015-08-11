//
//  ICloudSyncHelper.m
//  BlocNotes
//
//  Created by Diego Aguirre on 8/9/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "ICloudSyncHelper.h"
#import "AppDelegate.h"

static NSMetadataQuery *query;
static id delegate;
static NSURL *iCloudRoot;

@implementation ICloudSyncHelper

+ (void)startQuery
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       query = [[NSMetadataQuery alloc] init];
    });
    
    [self stopQuery];
    
    if (query) {
        
        [query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
        
        [query setPredicate:[NSPredicate predicateWithFormat:@"%K LIKE '*.realm'",
                             NSMetadataItemFSNameKey]];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:[self delegate]
                                             selector:@selector(processiCloudFiles:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[self delegate]
                                             selector:@selector(processiCloudFiles:)
                                                 name:NSMetadataQueryDidUpdateNotification
                                               object:nil];
    [query startQuery];
}

+ (void)stopQuery
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidUpdateNotification object:nil];

}

+ (void)downloadFileWithURL:(NSURL *)fileURL
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        
        [fileCoordinator coordinateReadingItemAtURL:fileURL options:NSFileCoordinatorReadingWithoutChanges error:nil byAccessor:^(NSURL *newURL) {
            
            NSFileManager * fileManager = [NSFileManager defaultManager];
            fileManager.delegate = delegate;
            NSError * error;
            BOOL success = [fileManager copyItemAtURL:fileURL toURL:[ICloudSyncHelper realmDatabaseURL] error:&error];
            if (success) {
                NSLog(@"Copied %@ to %@", fileURL, [ICloudSyncHelper realmDatabaseURL]);
            } else {
                NSLog(@"Failed to copy %@ to %@: %@", fileURL, [ICloudSyncHelper realmDatabaseURL], error.localizedDescription);
            }
        }];
    });
}

+ (void)uploadFileWithURL:(NSURL *)fileURL
{

    NSURL *destURL = [ICloudSyncHelper iCloudDatabaseURL];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        
        [fileCoordinator coordinateWritingItemAtURL:destURL options:NSFileCoordinatorWritingForDeleting error:nil byAccessor:^(NSURL *newURL) {
            NSError *error;
            NSFileManager * fileManager = [NSFileManager defaultManager];
            fileManager.delegate = delegate;
            BOOL success = [fileManager setUbiquitous:YES itemAtURL:fileURL destinationURL:destURL error:&error];
            if (success) {
                NSLog(@"Copied %@ to %@", fileURL, destURL);
            } else {
                NSLog(@"Failed to copy %@ to %@: %@", fileURL, destURL, error.localizedDescription);
            }
        }];
    });
}


+ (NSURL *)realmDatabaseURL
{
    NSURL *directory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.diegoa3d.BlocNotes"];
    return [directory URLByAppendingPathComponent:@"db.realm"];
}

+ (NSURL *)iCloudDatabaseURL
{
    return [[iCloudRoot URLByAppendingPathComponent:@"Documents" isDirectory:YES] URLByAppendingPathComponent:@"db.realm"];
}

+ (NSMetadataQuery *)query
{
    return query;
}

+ (id)delegate
{
    return delegate;
}

+ (void)setDelegate:(id)otherDelegate
{
    delegate = otherDelegate;
}


+ (void)setiCloudRoot:(NSURL *)root
{
    iCloudRoot = root;
}

@end
