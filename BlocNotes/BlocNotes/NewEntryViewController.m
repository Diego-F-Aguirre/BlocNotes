//
//  NewEntryViewController.m
//  BlocNotes
//
//  Created by Diego Aguirre on 7/21/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "NewEntryViewController.h"

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

- (void)dismissSelf{

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
    
}
- (IBAction)doneWasPressed:(id)sender {
    
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
