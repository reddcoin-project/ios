//
//  RDDQTExportParser.h
//  Reddcoin
//
//  Created by Adam McDonald on 9/17/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDDQTExportParser : NSObject
+ (NSNumber *)parseAmount:(id)amount;
+ (NSString *)normalizeTransactionID:(NSString *)transactionID;
@end
