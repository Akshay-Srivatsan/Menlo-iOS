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
+ (NSArray<NSString *> *)getAuthorizedTopics;

@end
