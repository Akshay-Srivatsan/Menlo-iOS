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
static NSDictionary<NSString *, NSDictionary<NSString *, NSString *> *> *users;

static NSString *email;
static NSString *displayName;
static NSString *uid;
static bool isAdmin;


+ (void)initializeApp {
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
                        
                    }];
                }];
            }];
            
        }];
    }];
    
    /*
     Register for notifications
     */
    UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

+ (NSString *)getUserNameForId:(NSString *)uid {
    return users[uid][@"displayName"];
}

+ (NSString *)getUserId {
    return uid;
}

+ (NSArray<NSString *> *)getAuthorizedTopics {
    NSLog(@"Authorized: %@", authorizedTopics);
    return authorizedTopics;
}

@end
