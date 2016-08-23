//
//  Suggestion.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/22/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "Suggestion.h"
#import "Database.h"
#import "MenloAppMain.h"

@implementation Suggestion

- (id)initWithId:(NSString *)suggestionId dictionary:(NSDictionary *)dictionary {
    self.suggestionId = suggestionId;
    self.title = dictionary[@"title"];
    self.text = dictionary[@"text"];
    if (dictionary[@"votes"] == nil) {
        self.votes = [[NSMutableDictionary alloc] init];
    } else {
        self.votes = [[NSMutableDictionary alloc] initWithDictionary:dictionary[@"votes"]];
    }
    self.author = dictionary[@"author"];
    self.timestamp = dictionary[@"timestamp"];
    return self;
}

- (id)init {
    self.suggestionId = nil;
    self.title = @"";
    self.text = @"";
    self.votes = [[NSMutableDictionary alloc] init];
    self.author = @"";
    return self;
}

- (void)save {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    data[@"title"] = self.title;
    data[@"text"] = self.text;
//    data[@"votes"] = self.votes;
//    if (self.votes.count == 0) {
//        data[@"votes"] = nil;
//    }
    data[@"author"] = self.author;
    
    if (self.suggestionId == nil) {
        data[@"timestamp"] = [Database getDatabaseTimestamp];
        data[@"author"] = [MenloAppMain getUserId];
        [Database pushDictionary:data atPath:@"suggestions" withHandler:^(NSDictionary *json) {
            
        }];
    } else {
        NSLog(@"%@", data);
        [Database putDictionary:data atPath:[@"suggestions/" stringByAppendingString:self.suggestionId] withHandler:^(NSDictionary *json) {
            NSLog(@"%@", json);
        }];
    }
}

- (int) getUpvoteCount {
    int upvotes = 0;
    for (NSString *key in self.votes) {
        if ([self.votes[key] intValue] == 1) {
            upvotes++;
        }
    }
    return upvotes;
}

- (int) getDownvoteCount {
    int upvotes = 0;
    for (NSString *key in self.votes) {
        if ([self.votes[key] intValue] == -1) {
            upvotes++;
        }
    }
    return upvotes;
}

- (int) getVoteForUser:(NSString *)user {
    for (NSString *key in self.votes) {
        if ([key isEqualToString:user]) {
            return [self.votes[key] intValue];
        }
    }
    return 0;
}

@end
