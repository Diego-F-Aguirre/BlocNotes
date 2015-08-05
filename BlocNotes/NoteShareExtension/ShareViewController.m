//
//  ShareViewController.m
//  NoteShareExtension
//
//  Created by Diego Aguirre on 8/4/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Realm/Realm.h>
#import "Note.h"

@interface ShareViewController ()

@property NSString *selectedText;

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    Note *newNote = [[Note alloc] initWithTitle:self.contentText body:self.selectedText];
    
    [realm beginWriteTransaction];
    [realm addObject:newNote];
    [realm commitWriteTransaction];
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    NSURL *directory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.diegoa3d.BlocNotes"];
    NSString *realmPath = [directory.path stringByAppendingPathComponent:@"db.realm"];
    [RLMRealm setDefaultRealmPath:realmPath];
    
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *jsDict, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *jsPreprocessingResults = jsDict[NSExtensionJavaScriptPreprocessingResultsKey];
                        self.selectedText = jsPreprocessingResults[@"selection"];
                        
                    });
                }];
                
                break;
            }
        }
        
    }
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
