//
//  SuggestionDetailViewController.h
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/22/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Suggestion;

@interface SuggestionDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *upvoteButton;
@property (weak, nonatomic) IBOutlet UIButton *downvoteButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property Suggestion *suggestion;

- (IBAction)upvote:(id)sender;
- (IBAction)downvote:(id)sender;


@end
