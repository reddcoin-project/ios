//
//  RDDElectrumClient.h
//  Reddcoin
//
//  Created by Adam McDonald on 9/13/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ElectrumSuccessBlock)();
typedef void (^ElectrumFailureBlock)(NSError *error);

@interface RDDElectrumClient : NSObject

- (void)sendAmount:(NSNumber *)amount
         toAddress:(NSString *)address
           success:(ElectrumSuccessBlock)success
           failure:(ElectrumFailureBlock)failure;

@end
