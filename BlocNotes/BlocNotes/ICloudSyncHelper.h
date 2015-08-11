//
//  ICloudSyncHelper.h
//  BlocNotes
//
//  Created by Diego Aguirre on 8/9/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ICloudSyncHelper : NSObject

+ (NSMetadataQuery *)query;
+ (id)delegate;
+ (void)setDelegate:(id)delegate;
+ (void)setiCloudRoot:(NSURL *)iCloudRoot;

+ (void)startQuery;
+ (void)stopQuery;
+ (void)downloadFileWithURL:(NSURL *)fileURL;
+ (void)uploadFileWithURL:(NSURL *)fileURL;

+ (NSURL *)realmDatabaseURL;
+ (NSURL *)iCloudDatabaseURL;
@end
