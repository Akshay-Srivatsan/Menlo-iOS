//
//  SuggestionEditViewController.h
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/22/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Suggestion;

@interface SuggestionEditViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *textTextView;
@property Suggestion *suggestion;

@end
