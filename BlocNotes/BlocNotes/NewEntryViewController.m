//
//  NewEntryViewController.m
//  BlocNotes
//
//  Created by Diego Aguirre on 7/21/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "NewEntryViewController.h"
#import "Note.h"

@interface NewEntryViewController ()

@property (strong, nonatomic) IBOutlet UITextField *noteTitle;

@end

@implementation NewEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Created a dismiss method to call when the cancel or done button are pressed
- (void)dismissSelf{

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//Imported the Realm Model object file to call when creating a new Note.
- (void)insertNoteTitle{

    Note *newNote = [Note new];
    newNote.title = self.noteTitle.text;
    newNote.body = @"";
    newNote.date = [NSDate date];
    
    //Must instatiate a realm database
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    //To write new note to database we must first call beginWritTransaction , add the new object and then commitWriteTransaction. This actually saves the object
    [realm beginWriteTransaction];
    [realm addObject:newNote];
    [realm commitWriteTransaction];
    
}

- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
    
}

// Call the insertNoteTitle and then dismiss the view
- (IBAction)doneWasPressed:(id)sender {
    [self insertNoteTitle];
    [self dismissSelf];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
