//
//  RDDContact.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDContact.h"

@implementation RDDContact

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

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[RDDContact class]]) {
        RDDContact *c = (RDDContact *)object;
        return [self.address isEqualToString:c.address];
    } else {
        return NO;
    }
}

@end
