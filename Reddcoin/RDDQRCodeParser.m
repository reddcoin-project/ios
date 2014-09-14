//
//  RDDQRCodeParser.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/13/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDQRCodeParser.h"

#import <NSURL+QueryDictionary/NSURL+QueryDictionary.h>
#import "RDDConstants.h"

@implementation RDDQRCodeParser

// Example: "reddcoin:RuUPmA82nTpKqGXrsrEShHNBBZ3xaH5NoU?amount=55.&message=RDD%20iOS%20QR"
+ (NSDictionary *)parse:(NSString *)scannedValue
{
    // reddcoin:<address> to reddcoin://<address> for easier parsing
    scannedValue = [scannedValue stringByReplacingOccurrencesOfString:@":" withString:@"://"];
    NSURL *url = [NSURL URLWithString:scannedValue];
    
    if ([[url scheme] isEqualToString:kReddcoinQRCodeScheme]) {
        // Build scanned data dictionary
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[url uq_queryDictionary]];
        [dictionary addEntriesFromDictionary:@{@"address" : [url host]}];
        return [NSDictionary dictionaryWithDictionary:dictionary];
    } else {
        return nil;
    }
}

@end
