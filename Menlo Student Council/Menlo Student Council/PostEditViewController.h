//
//  PostEditViewController.h
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/10/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post;

@interface PostEditViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *linkTextField;
@property (weak, nonatomic) IBOutlet UITextField *linkTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *textTextView;
@property Post *post;

- (IBAction)changeCategory:(id)sender;


@end
