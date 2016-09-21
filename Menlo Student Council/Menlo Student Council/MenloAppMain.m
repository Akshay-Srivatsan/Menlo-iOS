//
//  MenloAppMain.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/8/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "MenloAppMain.h"
#import "Database.h"
@import Firebase;
@import NotificationCenter;

@implementation MenloAppMain

static NSDictionary *authorization;
static NSMutableArray<NSString *> *authorizedTopics;
static NSMutableArray<NSString *> *admins;
static NSMutableArray<NSString *> *topics;
static NSDictionary<NSString *, NSDictionary<NSString *, id> *> *users;

static NSString *email;
static NSString *displayName;
static NSString *uid;
static bool isAdmin;
static NSMutableArray<NSString *>*subscribedTopics;


+ (void)initializeApp {
    
    
    /*
     Register for notifications
     */
    UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    /*
     Get all the data.
     */
    
    uid = [[FIRAuth auth] currentUser].uid;
    email = [[FIRAuth auth] currentUser].email;
    displayName = [[FIRAuth auth] currentUser].displayName;
    
    [Database initializeDatabaseWithHandler:^{
        
        [Database getDictionaryAtPath:@"authorization" withHandler:^(NSDictionary *json) {
            if (json == nil) {
                json = [[NSDictionary alloc] init];
            }
            authorization = json;
            NSLog(@"%@", authorization);
            
            [Database getDictionaryAtPath:@"admin" withHandler:^(NSDictionary *json) {
                if (json == nil) {
                    json = [[NSDictionary alloc] init];
                }
                admins = [[NSMutableArray alloc] init];
                NSLog(@"%@", admins);
                isAdmin = FALSE;
                for (NSString *key in json) {
                    if (json[key]) {
                        [admins addObject:key];
                        if ([key isEqualToString:uid]) {
                            isAdmin = YES;
                        }
                    }
                }
                
                [Database getDictionaryAtPath:@"topics" withHandler:^(NSDictionary *json) {
                    if (json == nil) {
                        json = [[NSDictionary alloc] init];
                    }
                    topics = [[NSMutableArray alloc] init];
                    authorizedTopics = [[NSMutableArray alloc] init];
                    for (NSString *key in json) {
                        [topics addObject:key];
                        if (isAdmin || (authorization[key] != nil && authorization[key][uid])) {
                            [authorizedTopics addObject:key];
                        }
                    }
                    
                    [Database getDictionaryAtPath:@"users" withHandler:^(NSDictionary *json) {
                        if (json == nil) {
                            json = [[NSDictionary alloc] init];
                        }
                        users = json;
                        
                        
                        [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
                            NSLog(@"FIRMessaging Error: %@", error);
                        }];
                        
                        subscribedTopics = [[NSMutableArray alloc] init];
                        [MenloAppMain subscribeToTopic:@"developer_override"];
                        
                        for (NSString *key in users[uid][@"topics"]) {
                            if ([((NSNumber *)(users[uid][@"topics"][key])) boolValue]) {
                                [MenloAppMain subscribeToTopic:key];
                                NSLog(@"!@#$%%^&*()  %@", key);
                            }
                        }
                        
                    }];
                }];
            }];
            
        }];
    }];
    
}

+ (NSString *)getUserNameForId:(NSString *)uid {
    return users[uid][@"displayName"];
}

+ (NSString *)getUserId {
    return uid;
}

+ (NSString *)getEmail {
    return email;
}

+ (NSArray<NSString *> *)getAuthorizedTopics {
    NSLog(@"Authorized: %@", authorizedTopics);
    return authorizedTopics;
}

+ (NSArray<NSString *> *)getTopics {
    return topics;
}

+ (void)subscribeToTopic:(NSString *)topic {
    [[FIRMessaging messaging] subscribeToTopic:[NSString stringWithFormat:@"/topics/%@", topic]];
    [subscribedTopics addObject:topic];
    NSLog(@"%@", subscribedTopics);
    NSData *data = [[[NSNumber numberWithBool:YES] stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    [Database putData:data atPath:[NSString stringWithFormat:@"/users/%@/topics/%@", uid, topic] withHandler:^(NSDictionary *json) {
        
    }];
}

+ (void)unsubscribeFromTopic:(NSString *)topic {
    [[FIRMessaging messaging] unsubscribeFromTopic:[NSString stringWithFormat:@"/topics/%@", topic]];
    [subscribedTopics removeObject:topic];
    NSLog(@"%@", subscribedTopics);
    NSData *data = [[[NSNumber numberWithBool:NO] stringValue] dataUsingEncoding:NSUTF8StringEncoding];
    [Database putData:data atPath:[NSString stringWithFormat:@"/users/%@/topics/%@", uid, topic] withHandler:^(NSDictionary *json) {
        
    }];
}

+ (BOOL)isSubscribedToTopic:(NSString *)topic {
    return [subscribedTopics containsObject:topic];
}

@end
