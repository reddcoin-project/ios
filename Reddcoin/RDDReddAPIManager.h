//
//  RDDReddAPIManager.h
//  Reddcoin
//
//  Created by Adam McDonald on 8/21/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface RDDReddAPIManager : AFHTTPRequestOperationManager
- (id)initWithGetKey:(NSString *)getKey postKey:(NSString *)postKey;
- (void)getUserInfoForUsername:(NSString *)username
                       success:(void (^)(NSDictionary *json))success
                       failure:(void (^)(NSError *error))failure;
- (void)getUserBalanceDetailForUsername:(NSString *)username
                                success:(void (^)(NSDictionary *json))success
                                failure:(void (^)(NSError *error))failure;
- (void)getUserListSuccess:(void (^)(NSArray *json))success
                   failure:(void (^)(NSError *error))failure;
- (void)sendFromUsername:(NSString *)username
               toAddress:(NSString *)address
                  amount:(NSNumber *)amount
                 success:(void (^)(NSDictionary *json))success
                 failure:(void (^)(NSError *error))failure;
- (void)sendFromUsername:(NSString *)usernameFrom
              toUsername:(NSString *)usernameTo
                  amount:(NSNumber *)amount
                 success:(void (^)(NSDictionary *json))success
                 failure:(void (^)(NSError *error))failure;
@end