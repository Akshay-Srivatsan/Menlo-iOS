//
//  Suggestion.h
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/22/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Suggestion : NSObject

@property NSString *suggestionId;
@property NSString *title;
@property NSString *text;
@property NSMutableDictionary<NSString *, NSNumber *> *votes;
@property NSString *author;
@property NSString *timestamp;


- (id)initWithId:(NSString *)suggestionId dictionary:(NSDictionary *)dictionary;
- (void)save;

- (int) getUpvoteCount;
- (int) getDownvoteCount;
- (int) getVoteForUser:(NSString *)user;

@end
