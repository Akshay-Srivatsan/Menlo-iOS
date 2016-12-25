//
//  Database.m
//  Menlo Student Council
//
//  Created by Akshay Srivatsan on 8/7/16.
//  Copyright © 2016 Akshay Srivatsan. All rights reserved.
//

#import "Database.h"
#import <GoogleSignIn/GoogleSignIn.h>
@import Firebase;

@implementation Database

static NSString *databasePath = @"https://menlo-ea5c9.firebaseio.com";
static NSString *token = nil;

+ (void)setToken:(NSString *)newToken {
    token = newToken;
}

+ (void)initializeDatabaseWithHandler:(void(^)(void))handler {
    [[[FIRAuth auth] currentUser] getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        [self setToken:token];
        
        handler();
    }];
}

+ (void)getDictionaryAtPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler {
    if (token == nil) {
        // Can't get any data until the authorization token arrives.
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json?auth=%@", databasePath, path, token]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        handler(json);
        
    }];
    
    [task resume];
    
    return;
}


+ (void)putDictionary:(NSDictionary *)data atPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler {
    if (token == nil) {
        // Can't do anything until the authorization token arrives.
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json?auth=%@", databasePath, path, token]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    NSData *dataObject = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    [request setHTTPBody:dataObject];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        handler(json);
        
    }];
    
    [task resume];
    
    return;
}

+ (void)putData:(NSData *)data atPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler {
    if (token == nil) {
        // Can't do anything until the authorization token arrives.
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json?auth=%@", databasePath, path, token]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    [request setHTTPBody:data];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        handler(json);
        
    }];
    
    [task resume];
    
    return;
}


+ (void)pushDictionary:(NSDictionary *)data atPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler {
    if (token == nil) {
        // Can't do anything until the authorization token arrives.
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json?auth=%@", databasePath, path, token]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSData *dataObject = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    [request setHTTPBody:dataObject];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        handler(json);
        
    }];
    
    [task resume];
    
    return;
}


+ (void)pushString:(NSString *)string atPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler {
    if (token == nil) {
        // Can't do anything until the authorization token arrives.
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json?auth=%@", databasePath, path, token]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSData *dataObject = [NSJSONSerialization dataWithJSONObject:string options:0 error:nil];
    [request setHTTPBody:dataObject];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        handler(json);
        
    }];
    
    [task resume];
    
    return;
}

+ (void)deleteDataAtPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler {
    if (token == nil) {
        // Can't get any data until the authorization token arrives.
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json?auth=%@", databasePath, path, token]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        handler(json);
        
    }];
    
    [task resume];
    
    return;
}


+ (void)deleteDictionaryAtPath:(NSString *)path withHandler:(void(^)(NSDictionary *json))handler {
    [self deleteDataAtPath:path withHandler:handler];
}

+ (NSDictionary *) getDatabaseTimestamp {
    return [FIRServerValue timestamp];
}

+ (void)updateNotifications {
    NSURL *url = [NSURL URLWithString:@"https://worker-aws-us-east-1.iron.io:443/2/projects/585c42c96bf1240007897ea4/tasks/webhook?code_name=Menlo+Student+Council+App&oauth=aTjV26fX2WbiFXDAr1wW"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    
    [task resume];
}


@end
