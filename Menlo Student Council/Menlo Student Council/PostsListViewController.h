//
//  FirstViewController.h
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/6/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsListViewController : UITableViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

