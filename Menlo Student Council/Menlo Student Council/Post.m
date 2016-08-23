//
//  Post.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/8/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "Post.h"
#import "Database.h"

@implementation Post

- (id)initWithId:(NSString *)postId dictionary:(NSDictionary *)dictionary {
    self.postId = postId;
    self.title = dictionary[@"title"];
    self.text = dictionary[@"text"];
    self.topic = dictionary[@"topic"];
    self.url = dictionary[@"url"];
    self.linkTitle = dictionary[@"link_title"];
    self.timestamp = dictionary[@"timestamp"];
    return self;
}

- (id)init {
    self.postId = nil;
    self.title = @"";
    self.text = @"";
    self.topic = @"";
    self.url = @"";
    self.linkTitle = @"";
    return self;
}

- (void)save {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    data[@"title"] = self.title;
    data[@"text"] = self.text;
    data[@"topic"] = self.topic;
    data[@"url"] = self.url;
    data[@"link_title"] = self.linkTitle;
    
    NSArray<NSString *> *keys = [data allKeys];
    
    for (NSString *key in keys) {
        if ([data[key] isEqualToString:@""]) {
            data[key] = nil;
        }
    }
    
    if (self.postId == nil) {
        data[@"timestamp"] = [Database getDatabaseTimestamp];
        [Database pushDictionary:data atPath:@"posts" withHandler:^(NSDictionary *json) {
            
        }];
    } else {
        [Database putDictionary:data atPath:[@"posts/" stringByAppendingString:self.postId] withHandler:^(NSDictionary *json) {
            
        }];
    }
}

@end
