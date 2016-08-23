//
//  SignInNavigationController.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/7/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "MainTabBarController.h"
#import "SignInViewController.h"
#import "MenloAppMain.h"

@import Firebase;

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if ([FIRAuth auth].currentUser == nil) {
        [self performSegueWithIdentifier:@"SignInSegue" sender:self];
    } else {
        [[GIDSignIn sharedInstance] signInSilently];
        [MenloAppMain initializeApp];
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

@end
