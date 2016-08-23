//
//  SecondViewController.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/6/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "SecondViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>

@import Firebase;

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    [[GIDSignIn sharedInstance] signOut];
    NSLog(@"Signing out");
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] performSegueWithIdentifier:@"SignInSegue" sender:self];
}
@end
