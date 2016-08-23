//
//  PostDetailViewController.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/8/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "PostDetailViewController.h"
#import "PostEditViewController.h"
#import "Post.h"
#import "MenloAppMain.h"

@interface PostDetailViewController ()

@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.post == nil) {
        self.titleLabel.text = @"Error";
        self.categoryLabel.text = @"Error";
        self.linkButton.enabled = NO;
        [self.linkButton setTitle:@"No Link Available" forState:UIControlStateNormal];
        self.textLabel.text = @"An error occurred. Please try again.";
        
    }
    
    if ([[MenloAppMain getAuthorizedTopics] containsObject:self.post.topic]) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editMode)];
        self.navigationItem.rightBarButtonItem = editButton;
    }
    NSLog(@"ViewDidLoad");
    
    self.titleLabel.text = self.post.title;
    self.categoryLabel.text = [@"Category: " stringByAppendingString:self.post.topic];;
    if (self.post.url != nil) {
        self.linkButton.enabled = YES;
        [self.linkButton setTitle:[@"Link: " stringByAppendingString:self.post.linkTitle] forState:UIControlStateNormal];
    } else {
        self.linkButton.enabled = NO;
        [self.linkButton setTitle:@"No Link Available" forState:UIControlStateNormal];
    }
    self.textLabel.text = self.post.text;
}

- (void)editMode {
    [self performSegueWithIdentifier:@"EditPostFromDetailsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditPostFromDetailsSegue"]) {
        PostEditViewController *edit = (PostEditViewController *)[segue destinationViewController];
        edit.post = self.post;
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

- (IBAction)linkClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.post.url]];
}



@end
