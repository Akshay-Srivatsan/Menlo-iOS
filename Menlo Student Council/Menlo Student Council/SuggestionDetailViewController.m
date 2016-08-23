//
//  SuggestionDetailViewController.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/22/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "SuggestionDetailViewController.h"
#import "SuggestionEditViewController.h"
#import "Suggestion.h"
#import "MenloAppMain.h"
#import "Database.h"

@interface SuggestionDetailViewController ()

@end

@implementation SuggestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.suggestion == nil) {
        self.titleLabel.text = @"Error";
        self.authorLabel.text = @"Error";
        self.upvoteButton.enabled = NO;
        self.downvoteButton.enabled = NO;
        self.textLabel.text = @"An error occurred. Please try again.";
        
    }
    
    if ([self.suggestion.author isEqualToString:[MenloAppMain getUserId]]) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editMode)];
        self.navigationItem.rightBarButtonItem = editButton;
    }
    
    [self updateView];
}

- (void)updateView {
    [self enableButtons];
    
    self.titleLabel.text = self.suggestion.title;
    self.authorLabel.text = [MenloAppMain getUserNameForId:self.suggestion.author];
    self.textLabel.text = self.suggestion.text;
    
    if ([[MenloAppMain getUserId] isEqualToString:self.suggestion.author]) {
        [self disableButtons];
    }
    int thisUserVote = [self.suggestion getVoteForUser:[MenloAppMain getUserId]];
    int ups = [self.suggestion getUpvoteCount];
    int downs = [self.suggestion getDownvoteCount];
    
    if (thisUserVote == 0) {
        [self.upvoteButton setTitle:[NSString stringWithFormat:@"👍 (%d)", ups] forState:UIControlStateNormal];
        [self.downvoteButton setTitle:[NSString stringWithFormat:@"👎 (%d)", downs] forState:UIControlStateNormal];
    } else if (thisUserVote == 1)  {
        [self.upvoteButton setTitle:[NSString stringWithFormat:@"👍 (%d) ✅", ups] forState:UIControlStateNormal];
        [self.downvoteButton setTitle:[NSString stringWithFormat:@"👎 (%d)", downs] forState:UIControlStateNormal];
    }  else if (thisUserVote == -1)  {
        [self.upvoteButton setTitle:[NSString stringWithFormat:@"👍 (%d)", ups] forState:UIControlStateNormal];
        [self.downvoteButton setTitle:[NSString stringWithFormat:@"👎 (%d) ✅", downs] forState:UIControlStateNormal];
    }
    [self.view setNeedsDisplay];
}

- (void)disableButtons {
    self.upvoteButton.enabled = NO;
    self.downvoteButton.enabled = NO;
}

- (void)enableButtons {
    self.upvoteButton.enabled = YES;
    self.downvoteButton.enabled = YES;
}

- (void)editMode {
    [self performSegueWithIdentifier:@"EditSuggestionFromDetailsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditSuggestionFromDetailsSegue"]) {
        SuggestionEditViewController *edit = (SuggestionEditViewController *)[segue destinationViewController];
        edit.suggestion = self.suggestion;
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

- (void)reload {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self enableButtons];
        [self updateView];
    });
}


- (IBAction)upvote:(id)sender {
    [self disableButtons];
    NSData *data;
    NSString *uid = [MenloAppMain getUserId];
    NSString *path = [NSString stringWithFormat:@"suggestions/%@/votes/%@", self.suggestion.suggestionId, uid];
    if ([self.suggestion getVoteForUser:[MenloAppMain getUserId]] != 1) {
        data = [[[NSNumber numberWithInt:1] stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        [Database putData:data atPath:path withHandler:^(NSDictionary *json) {
            self.suggestion.votes[uid] = [NSNumber numberWithInt:1];
            [self reload];
        }];
    } else {
        [Database deleteDataAtPath:path withHandler:^(NSDictionary *json) {
            self.suggestion.votes[uid] = [NSNumber numberWithInt:0];
            [self reload];
        }];
    }
}

- (IBAction)downvote:(id)sender {
    [self disableButtons];
    NSData *data;
    NSString *uid = [MenloAppMain getUserId];
    NSString *path = [NSString stringWithFormat:@"suggestions/%@/votes/%@", self.suggestion.suggestionId, uid];
    if ([self.suggestion getVoteForUser:[MenloAppMain getUserId]] != -1) {
        data = [[[NSNumber numberWithInt:-1] stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        [Database putData:data atPath:path withHandler:^(NSDictionary *json) {
            self.suggestion.votes[uid] = [NSNumber numberWithInt:-1];
            [self reload];
        }];
    } else {
        [Database deleteDataAtPath:path withHandler:^(NSDictionary *json) {
            self.suggestion.votes[uid] = [NSNumber numberWithInt:0];
            [self reload];
        }];
    }
}

@end
