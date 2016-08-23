//
//  PostDetailViewController.h
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/8/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post;

@interface PostDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property Post *post;
- (IBAction)linkClicked:(id)sender;

@end
