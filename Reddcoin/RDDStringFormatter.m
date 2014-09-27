//
//  RDDStringFormatter.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/9/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDStringFormatter.h"

#import "RDDConstants.h"

#define MAX_FRACTIONAL_DIGITS 8

@implementation RDDStringFormatter

+ (NSString *)formatAmount:(NSNumber *)amount includeCurrencyCode:(BOOL)includeCurrencyCode
{
    NSInteger numFractionDigits = 0;
    NSArray *components = [[amount stringValue] componentsSeparatedByString:@"."];
    if ([components count] == 2) {
        NSString *fractionDigits = components[1];
        numFractionDigits = [fractionDigits length];
    }
    numFractionDigits = MIN(numFractionDigits, MAX_FRACTIONAL_DIGITS);
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:numFractionDigits];
    
    NSString *numberAsString = [numberFormatter stringFromNumber:amount];
    
    if (includeCurrencyCode) {
        numberAsString = [numberAsString stringByAppendingFormat:@" %@", kReddcoinCurrencyCode];
    }
    
    return numberAsString;
}

@end
