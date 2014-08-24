//
//  RDDReddAPIManager.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/21/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDReddAPIManager.h"

#import "RDDConstants.h"

@interface RDDReddAPIManager ()
@property (nonatomic, strong) NSString *getKey;
@property (nonatomic, strong) NSString *postKey;
@end

@implementation RDDReddAPIManager

- (id)initWithGetKey:(NSString *)getKey postKey:(NSString *)postKey
{
    self = [super init];
    if (self) {
        self.getKey = getKey;
        self.postKey = postKey;
    }
    return self;
}

- (NSURL *)baseURL
{
    return [NSURL URLWithString:kReddAPIBaseURL];
}

- (AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer
{
    return [AFJSONResponseSerializer serializer];
}

- (NSString *)prepareGetURLStringWithPath:(NSString *)path username:(NSString *)username
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:path];
    url = [url URLByAppendingPathComponent:self.getKey];
    if (username) {
        url = [url URLByAppendingPathComponent:username];
    }
    return [url absoluteString];
}

- (NSString *)preparePostURLStringWithPath:(NSString *)path
{
    return [[self.baseURL URLByAppendingPathComponent:path] absoluteString];
}

- (void)getUserInfoForUsername:(NSString *)username
                       success:(void (^)(NSDictionary *json))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *urlString = [self prepareGetURLStringWithPath:@"GetUserInfo" username:username];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [self.operationQueue addOperation:requestOperation];
}

- (void)getUserBalanceDetailForUsername:(NSString *)username
                                success:(void (^)(NSDictionary *json))success
                                failure:(void (^)(NSError *error))failure
{
    NSString *urlString = [self prepareGetURLStringWithPath:@"GetUserBalanceDetail" username:username];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [self.operationQueue addOperation:requestOperation];
}

- (void)sendFromUsername:(NSString *)username
               toAddress:(NSString *)address
                  amount:(NSNumber *)amount
                 success:(void (^)(NSDictionary *json))success
                 failure:(void (^)(NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *urlString = [self preparePostURLStringWithPath:@"SendToAddress"];
    NSDictionary *params = @{@"APIKey" : self.postKey, @"UsernameFrom" : username, @"AddressTo" : address, @"Amount" : amount};
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    /// TODO: HACK around invalid ReddAPI response (returns only "Success" string)
    requestOperation.responseSerializer = [AFHTTPResponseSerializer serializer];
    /// TODO: HACK
    [self.operationQueue addOperation:requestOperation];
}

- (void)sendFromUsername:(NSString *)usernameFrom
              toUsername:(NSString *)usernameTo
                  amount:(NSNumber *)amount
                 success:(void (^)(NSDictionary *json))success
                 failure:(void (^)(NSError *error))failure
{
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *urlString = [self preparePostURLStringWithPath:@"MoveToUser"];
    NSDictionary *params = @{@"APIKey" : self.postKey, @"UsernameFrom" : usernameFrom, @"UsernameTo" : usernameTo, @"Amount" : amount};
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    /// TODO: HACK around invalid ReddAPI response (returns only "Success" string)
    requestOperation.responseSerializer = [AFHTTPResponseSerializer serializer];
    /// TODO: HACK
    [self.operationQueue addOperation:requestOperation];
}

@end
