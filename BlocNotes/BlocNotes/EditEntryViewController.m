//
//  EditEntryViewController.m
//  BlocNotes
//
//  Created by Diego Aguirre on 7/27/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "EditEntryViewController.h"
#import "Note.h"

@interface EditEntryViewController ()
@property (strong, nonatomic) IBOutlet UITextView *noteBodyTextView;

@end

@implementation EditEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = true;

    //Initialize a UITapGestureRecognizer to require one tap to make the textView editable. In IB the text view is initialized as uneditable to allow UIDataDetector to stay active.
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTextRecognizerTabbed:)];
    recognizer.delegate = self;
    recognizer.numberOfTapsRequired = 1;
    [self.noteBodyTextView addGestureRecognizer:recognizer];
}

//Method to turn make the textView editable as well as turn off UIDataDetector
- (void) editTextRecognizerTabbed:(UITapGestureRecognizer *) aRecognizer;
{
    self.noteBodyTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.noteBodyTextView.editable = YES;
    [self.noteBodyTextView becomeFirstResponder];
}
//Turn off editable on textView and turn on UIDataDetector
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    self.noteBodyTextView.editable = NO;
    self.noteBodyTextView.dataDetectorTypes = UIDataDetectorTypeAll;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.noteBodyTextView.text = self.note.body;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Created a dismiss method to call when back button is pressed
- (void)dismissSelf{
    [self.navigationController popViewControllerAnimated:YES];
}

//Recall an instance defaultRealm which contains our databse/information
- (void)editNote{

    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    //To write new note to database we must first call beginWritTransaction , add the new object and then commitWriteTransaction. This actually saves the object
    [realm beginWriteTransaction];
    //simply include the property of the textview you want to edit which recalls the body from Note.h
    self.note.body = self.noteBodyTextView.text;
    [realm commitWriteTransaction];
}

//Back button returns to previous screen and saves updated info
- (IBAction)backButtonWasPressed:(id)sender {
    [self editNote];
    [self dismissSelf];
}

- (IBAction)shareButtonWasPressed:(id)sender {
    
    NSMutableArray *itemToShare = [NSMutableArray array];
    
    if (self.noteBodyTextView.text > 0) {
        [itemToShare addObject:self.noteBodyTextView];
    }
    
    if (itemToShare.count > 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemToShare applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];

    }
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
