//
//  RDDStringFormatter.h
//  Reddcoin
//
//  Created by Adam McDonald on 9/9/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDDStringFormatter : NSObject
+ (NSString *)formatAmount:(NSNumber *)amount includeCurrencyCode:(BOOL)includeCurrencyCode;
@end
