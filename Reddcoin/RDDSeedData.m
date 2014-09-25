//
//  RDDSeedData.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDSeedData.h"

#import "RDDContact.h"
#import "RDDReceivingAddress.h"
#import "RDDTransaction.h"

NSString * const RDDContactsKey = @"RDDContactsKey";
NSString * const RDDReceivingAddressesKey = @"RDDReceivingAddressesKey";
NSString * const RDDTransactionsKey = @"RDDTransactionsKey";

@implementation RDDSeedData

- (void)generate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *contacts = [self contacts];
    if (contacts && [contacts count] > 0) return; // Seed data already generated
    
    NSLog(@"Seeding data...");
    
    // Contacts / Addresses
    contacts = [self buildContacts];
    NSData *contactsData = [NSKeyedArchiver archivedDataWithRootObject:contacts];
    [defaults setObject:contactsData forKey:RDDContactsKey];
    
    // Receiving Addresses
    NSArray *addresses = [self buildReceivingAddresses];
    NSData *addressesData = [NSKeyedArchiver archivedDataWithRootObject:addresses];
    [defaults setObject:addressesData forKey:RDDReceivingAddressesKey];
    
    // Transactions
    NSArray *transactions = [self buildTransactions];
    NSData *transactionsData = [NSKeyedArchiver archivedDataWithRootObject:transactions];
    [defaults setObject:transactionsData forKey:RDDTransactionsKey];
    
    // Persist everything.
    [defaults synchronize];
}

- (NSArray *)contacts
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *contactsData = [defaults objectForKey:RDDContactsKey];
    NSArray *contacts = [NSKeyedUnarchiver unarchiveObjectWithData:contactsData];
    return contacts;
}

- (NSArray *)receivingAddresses
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *addressesData = [defaults objectForKey:RDDReceivingAddressesKey];
    NSArray *addresses = [NSKeyedUnarchiver unarchiveObjectWithData:addressesData];
    return addresses;
}

- (NSArray *)transactions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *transactionsData = [defaults objectForKey:RDDTransactionsKey];
    NSArray *transactions = [NSKeyedUnarchiver unarchiveObjectWithData:transactionsData];
    return transactions;
}

- (NSArray *)buildContacts
{
    NSMutableArray *contacts = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        RDDContact *contact = [[RDDContact alloc] init];
        contact.address = [self randomFakeReddcoinAddress];
        contact.label = [NSString stringWithFormat:@"Contact label %d", i];
        [contacts addObject:contact];
    }
    return contacts;
}

- (NSArray *)buildReceivingAddresses
{
    NSMutableArray *addresses = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        RDDReceivingAddress *address = [[RDDReceivingAddress alloc] init];
        address.address = [self randomFakeReddcoinAddress];
        address.label = [NSString stringWithFormat:@"Label %d", i];
        [addresses addObject:address];
    }
    return addresses;
}

- (NSArray *)buildTransactions
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"reddcoin-transactions" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *transactionsJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *transactions = [NSMutableArray array];
    for (NSDictionary *t in transactionsJSON) {
        RDDTransaction *transaction = [[RDDTransaction alloc] initWithDictionary:t];
        [transactions addObject:transaction];
    }
    return transactions;
}

- (NSString *)randomFakeReddcoinAddress
{
    return [@"RFAKE" stringByAppendingString:[self randomStringWithLength:29]];
}

- (NSString *)randomStringWithLength:(int)len
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:len];
    for (NSUInteger i = 0U; i < len; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

@end
