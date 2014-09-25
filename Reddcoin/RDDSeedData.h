//
//  RDDSeedData.h
//  Reddcoin
//
//  Created by Adam McDonald on 9/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDDSeedData : NSObject
- (void)generate;
- (NSArray *)contacts;
- (NSArray *)receivingAddresses;
- (NSArray *)transactions;
@end
