//
//  SuggestionsListViewController.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/22/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "SuggestionsListViewController.h"
#import "Database.h"
#import "Suggestion.h"
#import "SuggestionDetailViewController.h"
#import "SuggestionEditViewController.h"
#import "MenloAppMain.h"


@interface SuggestionsListViewController ()

@end

@implementation SuggestionsListViewController

NSMutableArray<Suggestion *> *suggestions;
NSMutableArray<Suggestion *> *filteredSuggestions;
Suggestion *targetSuggestion;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchBar setDelegate:self];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 10;
    
    
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
    suggestions = [NSMutableArray array];
    [self.refreshControl beginRefreshing];
    [Database getDictionaryAtPath:@"suggestions" withHandler:^(NSDictionary *json) {
        for (id key in json) {
            [suggestions addObject:[[Suggestion alloc] initWithId:key dictionary:json[key]]];
        }
        suggestions = [NSMutableArray arrayWithArray:[suggestions sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [((Suggestion *)obj2).suggestionId compare:((Suggestion *)obj1).suggestionId];
        }]];
        filteredSuggestions = [NSMutableArray arrayWithArray:suggestions];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Got Suggestions" object:self];
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
    return [filteredSuggestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Post" forIndexPath:indexPath];
    
    Suggestion *current = filteredSuggestions[indexPath.row];
    NSString *title = current.title;
    NSString *message = current.text;
    NSString *author = current.author;
    
    NSString *votesString;
    
    int ups = [current getUpvoteCount];
    int downs = [current getDownvoteCount];
    
    /*
    if ((ups == 0) && (downs == 0)) {
        votesString = @"No Votes";
    } else if ((ups != 0) && (downs == 0)) {
        votesString = [@"👍: " stringByAppendingString:[NSString stringWithFormat:@"%d", ups]];
    } else if ((ups == 0) && (downs != 0)) {
        votesString = [@"👎: " stringByAppendingString:[NSString stringWithFormat:@"%d", downs]];
    } else {
        votesString = [@"👍: " stringByAppendingString:[NSString stringWithFormat:@"%d", ups]];
        votesString = [votesString stringByAppendingString:@"\n"];
        votesString = [votesString stringByAppendingString:[@"👎: " stringByAppendingString:[NSString stringWithFormat:@"%d", downs]]];
    }
    */
    
    int thisUserVote = [current getVoteForUser:[MenloAppMain getUserId]];
    
    votesString = [@"👍: " stringByAppendingString:[NSString stringWithFormat:@"%d", ups]];
    if (thisUserVote == 1) {
        votesString = [votesString stringByAppendingString:@" ✅"];
    }
    votesString = [votesString stringByAppendingString:@"\n"];
    votesString = [votesString stringByAppendingString:[@"👎: " stringByAppendingString:[NSString stringWithFormat:@"%d", downs]]];
    if (thisUserVote == -1) {
        votesString = [votesString stringByAppendingString:@" ✅"];
    }
    
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:10];
    UILabel *messageLabel = (UILabel *)[cell.contentView viewWithTag:20];
    UILabel *authorLabel = (UILabel *)[cell.contentView viewWithTag:30];
    UILabel *votesLabel = (UILabel *)[cell.contentView viewWithTag:40];
    
    titleLabel.text = title;
    messageLabel.text = message;
    authorLabel.text = [MenloAppMain getUserNameForId:author];
    votesLabel.text = votesString;
    
    
    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    targetSuggestion = filteredSuggestions[indexPath.row];
    [self performSegueWithIdentifier:@"ShowSuggestionDetailsSegue" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [filteredSuggestions[indexPath.row].author isEqualToString:[MenloAppMain getUserId]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Suggestion *suggestion = suggestions[indexPath.row];
        [Database deleteDictionaryAtPath:[@"suggestions/" stringByAppendingString:suggestion.suggestionId] withHandler:^(NSDictionary *json) {
            [self reload];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowSuggestionDetailsSegue"]) {
        SuggestionDetailViewController *detail = (SuggestionDetailViewController *)[segue destinationViewController];
        detail.suggestion = targetSuggestion;
    } else if ([[segue identifier] isEqualToString:@"NewSuggestionSegue"]) {
        SuggestionEditViewController *edit = (SuggestionEditViewController *)[segue destinationViewController];
        edit.suggestion = [[Suggestion alloc] init];
    }
}
/*
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
*/

@end
