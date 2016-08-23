//
//  PostEditViewController.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/10/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "PostEditViewController.h"
#import "Post.h"
#import "MenloAppMain.h"

@interface PostEditViewController ()

@end

@implementation PostEditViewController

NSString *newCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveClicked)];
    self.navigationItem.rightBarButtonItem = saveButton;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.post == nil) {
        self.titleTextField.text = @"Error";
        self.categoryLabel.text = @"Error";
        self.linkTextField.hidden = YES;
        self.linkTextField.hidden = YES;
        self.textTextView.text = @"An error occurred. Please try again.";
        
    }
    self.titleTextField.text = self.post.title;
    self.categoryLabel.text = [@"Category: " stringByAppendingString:self.post.topic];
    newCategory = self.post.topic;
    self.linkTextField.text = self.post.url;
    self.linkTitleTextField.text = self.post.linkTitle;
    self.textTextView.text = self.post.text;
    
    if ([self.post.topic isEqual: @""]) {
        newCategory = [MenloAppMain getAuthorizedTopics][0];
        self.categoryLabel.text = [@"Category: " stringByAppendingString:newCategory];
    }
    
    if (self.post.text == nil || [self.post.text  isEqual: @""]) {
        self.textTextView.delegate = self;
        self.textTextView.textColor = [UIColor lightGrayColor];
        self.textTextView.text = @"Post Text";
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
    valid &= (newCategory != nil);
    valid &= (![self.linkTextField.text isEqualToString:@""] ||
              !([self.textTextView.text isEqualToString:@"Post Text"] || [self.textTextView.text isEqualToString:@""]));
    if (![self.linkTextField.text isEqualToString:@""] && [self.linkTitleTextField.text isEqualToString:@""]) {
        self.linkTitleTextField.text = self.linkTextField.text;
    }
    if (valid) {
        self.post.title = self.titleTextField.text;
        self.post.linkTitle = self.linkTitleTextField.text;
        self.post.url = self.linkTextField.text;
        self.post.topic = newCategory;
        self.post.text = self.textTextView.text;
        if ([self.post.text isEqual: @"Post Text"]) {
            self.post.text = nil;
        }
        [self.post save];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Incomplete Post" message:@"Specify a title, category, and either a link or message text." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [actionSheet addAction:cancel];
        [self presentViewController:actionSheet animated:YES completion:nil];
        
    }
}

- (IBAction)changeCategory:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"Choose a Category:" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (newCategory != nil) {
        UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheet addAction:dismiss];
    }
    
    for (NSString *topic in [MenloAppMain getAuthorizedTopics]) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:topic style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            newCategory = topic;
            self.categoryLabel.text = [@"Category: " stringByAppendingString:newCategory];
            
        }];
        [actionSheet addAction:action];
    }
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqual: @"Post Text"]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqual: @""]) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Post Text";
    }
}


@end
