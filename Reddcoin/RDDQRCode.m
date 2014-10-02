//
//  RDDQRCodeParser.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/13/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDQRCode.h"

#import <NSURL+QueryDictionary/NSURL+QueryDictionary.h>
#import "RDDConstants.h"
#import "RDDReceivingAddress.h"

// Example
// "reddcoin:RuUPmA82nTpKqGXrsrEShHNBBZ3xaH5NoU?amount=55.&label=somelabel&message=RDD%20iOS%20QR"

@implementation RDDQRCode

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

+ (NSString *)generate:(RDDReceivingAddress *)address
{
    NSString *urlString = [NSString stringWithFormat:@"reddcoin://%@", address.address];
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *params = @{@"label" : address.label};
    url = [url uq_URLByAppendingQueryDictionary:params];
    NSLog(@"%@", url.absoluteString);
    urlString = [url.absoluteString stringByReplacingOccurrencesOfString:@"://" withString:@":"];
    NSLog(@"%@", urlString);
    return urlString;
}

@end
