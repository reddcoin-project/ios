//
//  RDDElectrumClient.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/13/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDElectrumClient.h"

@implementation RDDElectrumClient

- (void)sendAmount:(NSNumber *)amount
         toAddress:(NSString *)address
           success:(ElectrumSuccessBlock)success
           failure:(ElectrumFailureBlock)failure
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        success();
    });
}

@end
