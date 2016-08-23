//
//  PostsListViewController.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/6/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "PostsListViewController.h"
#import "Database.h"
#import "Post.h"
#import "PostDetailViewController.h"
#import "PostEditViewController.h"
#import "MenloAppMain.h"


@interface PostsListViewController ()

@end

@implementation PostsListViewController

NSMutableArray<Post *> *posts;
NSMutableArray<Post *> *filteredPosts;
Post *targetPost;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchBar setDelegate:self];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    
    [self.navigationItem.leftBarButtonItem setAction:@selector(editMode)];
    [self.navigationItem.leftBarButtonItem setTarget:self];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [self reload];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)reload {
    [self.searchBar setText:@""];
    posts = [NSMutableArray array];
    [self.refreshControl beginRefreshing];
    [Database getDictionaryAtPath:@"posts" withHandler:^(NSDictionary *json) {
        for (id key in json) {
            [posts addObject:[[Post alloc] initWithId: key dictionary:json[key]]];
        }
        posts = [NSMutableArray arrayWithArray:[posts sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [((Post *)obj2).postId compare:((Post *)obj1).postId];
        }]];
        filteredPosts = [NSMutableArray arrayWithArray:posts];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Got Posts" object:self];
        [self.refreshControl endRefreshing];
    }];

}

- (void)editMode {
    NSLog(@"Edit!");
    if (self.editing) {
        [self setEditing:NO];
        self.navigationItem.leftBarButtonItem.title = @"Edit";
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    } else {
        [self setEditing:YES];
        self.navigationItem.leftBarButtonItem.title = @"Done";
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There's just one (infinite) section - the posts.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filteredPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Post" forIndexPath:indexPath];
    
    NSString *title = filteredPosts[indexPath.row].title;
    NSString *category = filteredPosts[indexPath.row].topic;
    NSString *message = filteredPosts[indexPath.row].text;
    NSString *linkTitle = filteredPosts[indexPath.row].linkTitle;
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:10];
    UILabel *categoryLabel = (UILabel *)[cell.contentView viewWithTag:20];
    UILabel *messageLabel = (UILabel *)[cell.contentView viewWithTag:30];
    UILabel *linkLabel = (UILabel *)[cell.contentView viewWithTag:40];
    
    titleLabel.text = title;
    categoryLabel.text = category;
    messageLabel.text = message;
        
    if (linkTitle == nil) {
        linkLabel.text = @"";
    } else {
        linkLabel.text = [@"Link: " stringByAppendingString:linkTitle];
    }
    
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    targetPost = filteredPosts[indexPath.row];
    [self performSegueWithIdentifier:@"ShowPostDetailsSegue" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[MenloAppMain getAuthorizedTopics] containsObject:posts[indexPath.row].topic];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Post *post = posts[indexPath.row];
        [Database deleteDictionaryAtPath:[@"posts/" stringByAppendingString:post.postId] withHandler:^(NSDictionary *json) {
            [self reload];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPostDetailsSegue"]) {
        PostDetailViewController *detail = (PostDetailViewController *)[segue destinationViewController];
        detail.post = targetPost;
    } else if ([[segue identifier] isEqualToString:@"NewPostSegue"]) {
        PostEditViewController *edit = (PostEditViewController *)[segue destinationViewController];
        edit.post = [[Post alloc] init];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *filterText = [searchText lowercaseString];
    [filteredPosts removeAllObjects];
    
    if ([filterText isEqualToString:@""]) {
        [filteredPosts addObjectsFromArray:posts];
        [self.tableView reloadData];
        return;
    }
    
    for (Post *post in posts) {
        if ([[post.title lowercaseString] containsString:filterText] || [[post.topic lowercaseString] containsString:filterText] || [[post.text lowercaseString] containsString:filterText] || [[post.linkTitle lowercaseString] containsString:filterText]) {
            [filteredPosts addObject:post];
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
