//
//  RDDStringFormatter.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/9/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDStringFormatter.h"

#import "RDDConstants.h"

@implementation RDDStringFormatter

+ (NSString *)formatAmount:(NSNumber *)amount includeCurrencyCode:(BOOL)includeCurrencyCode
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *numberAsString = [numberFormatter stringFromNumber:amount];
    
    if (includeCurrencyCode) {
        numberAsString = [numberAsString stringByAppendingFormat:@" %@", kReddcoinCurrencyCode];
    }
    
    return numberAsString;
}

@end
