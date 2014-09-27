//
//  RDDSeedData.h
//  Reddcoin
//
//  Created by Adam McDonald on 9/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDDContact, RDDReceivingAddress, RDDTransaction;

@interface RDDSeedData : NSObject
- (void)generate;
- (NSArray *)contacts;
- (NSArray *)receivingAddresses;
- (NSArray *)transactions;
- (void)addContact:(RDDContact *)contact;
- (void)addReceivingAddress:(RDDReceivingAddress *)address;
- (void)addTransaction:(RDDTransaction *)transaction;
- (void)prependTransaction:(RDDTransaction *)transaction;
@end
