//
//  Database.h
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/7/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

+ (void)initializeDatabaseWithHandler:(void(^)(void))handler;
+ (void)getDictionaryAtPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler;
+ (void)putDictionary:(NSDictionary *)data atPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler;
+ (void)putData:(NSData *)data atPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler;
+ (void)pushDictionary:(NSDictionary *)data atPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler;
+ (void)pushString:(NSString *)string atPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler;
+ (void)deleteDataAtPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler;
+ (void)deleteDictionaryAtPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler;

+ (NSDictionary *) getDatabaseTimestamp;
@end
