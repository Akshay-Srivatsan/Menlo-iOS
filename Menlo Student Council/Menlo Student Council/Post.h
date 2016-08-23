//
//  Post.h
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/8/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property NSString *postId;
@property NSString *title;
@property NSString *text;
@property NSString *url;
@property NSString *linkTitle;
@property NSString *topic;
@property NSString *timestamp;

- (id)initWithId:(NSString *)postId dictionary:(NSDictionary *)dictionary;
- (void)save;

@end
