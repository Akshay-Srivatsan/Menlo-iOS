//
//  SignInViewController.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/7/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "SignInViewController.h"
#import "MenloAppMain.h"

@import Firebase;

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInComplete:) name:@"Sign In" object:nil];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signInSilently];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signInComplete:(NSNotification *) notification {
    [MenloAppMain initializeApp];
    [self dismissViewControllerAnimated:YES completion:nil];
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
