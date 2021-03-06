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
@property (strong, nonatomic) IBOutlet UITextView *noteBodyTextView;

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

    // Alloc and instatiate the realm note model and set it's properties
    Note *newNote = [Note createNoteWithTitle:self.noteTitle.text body:self.noteBodyTextView.text];
    [newNote save];
    
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
