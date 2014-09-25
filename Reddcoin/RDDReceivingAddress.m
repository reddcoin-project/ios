//
//  RDDReceivingAddress.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDReceivingAddress.h"

@implementation RDDReceivingAddress

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        self.address = [decoder decodeObjectForKey:@"address"];
        self.label = [decoder decodeObjectForKey:@"label"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.label forKey:@"label"];
}

@end
