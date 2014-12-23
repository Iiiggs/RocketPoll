////
////  ParseStarterProjectViewController.m
////  ParseStarterProject
////
////  Copyright 2014 Parse, Inc. All rights reserved.
////
//
//#import "ParseStarterProjectViewController.h"
//
//#import <Parse/Parse.h>
//
//@implementation ParseStarterProjectViewController
//
//#pragma mark - UIViewController
//
//// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    PFUser *user = [PFUser user];
//    user.username = @"Iiiggs2";
//    user.password = @"abc123";
//    user.email = @"igorkantor@icloud.com";
//
//    // other fields can be set if you want to save more information
//    user[@"phone"] = @"650-555-0000";
//
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            // Hooray! Let them use the app now.
//            NSLog(@"Registered");
//        } else {
//            NSString *errorString = [error userInfo][@"error"];
//            // Show the errorString somewhere and let the user try again.
//            NSLog(@"%@", errorString);
//        }
//    }];
//}
//
//- (void)didReceiveMemoryWarning {
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//
//    // Release any cached data, images, etc that aren't in use.
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//@end
