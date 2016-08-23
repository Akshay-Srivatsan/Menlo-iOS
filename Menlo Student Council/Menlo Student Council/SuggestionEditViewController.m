//
//  SuggestionEditViewController.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/22/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "SuggestionEditViewController.h"
#import "Suggestion.h"
#import "MenloAppMain.h"

@interface SuggestionEditViewController ()

@end

@implementation SuggestionEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveClicked)];
    self.navigationItem.rightBarButtonItem = saveButton;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.suggestion == nil) {
        self.titleTextField.text = @"Error";
        self.textTextView.text = @"An error occurred. Please try again.";
        
    }
    self.titleTextField.text = self.suggestion.title;
    self.textTextView.text = self.suggestion.text;
    
    if (self.suggestion.text == nil || [self.suggestion.text  isEqual: @""]) {
        self.textTextView.delegate = self;
        self.textTextView.textColor = [UIColor lightGrayColor];
        self.textTextView.text = @"Description";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)saveClicked {
    bool valid = true;
    valid &= ![self.titleTextField.text isEqualToString:@""];
    valid &= !([self.textTextView.text isEqualToString:@"Description"] || [self.textTextView.text isEqualToString:@""]);
    
    if (valid) {
        self.suggestion.title = self.titleTextField.text;
        self.suggestion.text = self.textTextView.text;
        [self.suggestion save];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Incomplete Post" message:@"Specify a title and a description" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [actionSheet addAction:cancel];
        [self presentViewController:actionSheet animated:YES completion:nil];
        
    }
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqual: @"Description"]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqual: @""]) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Description";
    }
}


@end
