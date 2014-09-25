//
//  RDDTransaction.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDTransaction.h"

#import "RDDQTExportParser.h"
#import "RDDStringFormatter.h"

@implementation RDDTransaction

- (id)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if (self) {
        self.address = dictionary[@"Address"];
        self.amount = [RDDQTExportParser parseAmount:dictionary[@"Amount"]];
        self.confirmed = [dictionary[@"Confirmed"] boolValue];
        self.dateString = dictionary[@"Date"];
        self.label = dictionary[@"Label"];
        self.transactionID = [RDDQTExportParser normalizeTransactionID:dictionary[@"ID"]];
        self.type = dictionary[@"Type"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        self.address = [decoder decodeObjectForKey:@"address"];
        self.amount = [decoder decodeObjectForKey:@"amount"];
        self.confirmed = [[decoder decodeObjectForKey:@"confirmed"] boolValue];
        self.dateString = [decoder decodeObjectForKey:@"dateString"];
        self.label = [decoder decodeObjectForKey:@"label"];
        self.transactionID = [decoder decodeObjectForKey:@"transactionID"];
        self.type = [decoder decodeObjectForKey:@"type"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.amount forKey:@"amount"];
    [encoder encodeObject:@(self.confirmed) forKey:@"confirmed"];
    [encoder encodeObject:self.dateString forKey:@"dateString"];
    [encoder encodeObject:self.label forKey:@"label"];
    [encoder encodeObject:self.transactionID forKey:@"transactionID"];
    [encoder encodeObject:self.type forKey:@"type"];
}

@end
