//
//  RDDQTExportParser.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/17/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDQTExportParser.h"

@implementation RDDQTExportParser

+ (NSNumber *)parseAmount:(id)amount
{
    NSNumber *amt;
    if ([amount isKindOfClass:[NSNumber class]]) {
        // 124.123
        amt = amount;
    } else {
        // "1 234.123"
        NSString *str = amount;
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        amt = @([str floatValue]);
    }
    return amt;
}

+ (NSString *)normalizeTransactionID:(NSString *)transactionID
{
    if ([transactionID hasSuffix:@"-000"]) {
        transactionID = [transactionID stringByReplacingOccurrencesOfString:@"-000" withString:@""];
    }
    return transactionID;
}

@end
