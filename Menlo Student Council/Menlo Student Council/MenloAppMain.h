//
//  MenloAppMain.h
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/8/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenloAppMain : NSObject

+ (void)initializeApp;

+ (NSString *)getUserNameForId:(NSString *)uid;
+ (NSString *)getUserId;
+ (NSString *)getEmail;
+ (NSArray<NSString *> *)getAuthorizedTopics;
+ (NSArray<NSString *> *)getTopics;
+ (void)subscribeToTopic:(NSString *)topic;
+ (void)unsubscribeFromTopic:(NSString *)topic;
+ (BOOL)isSubscribedToTopic:(NSString *)topic;

@end
