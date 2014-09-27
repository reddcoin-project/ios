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

@interface RDDSeedData ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation RDDSeedData

- (id)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)generate
{
    NSArray *contacts = [self contacts];
    if (contacts && [contacts count] > 0) return; // Seed data already generated
    
    NSLog(@"Seeding data...");
    
    // Contacts / Addresses
    contacts = [self buildContacts];
    [self persistContacts:contacts];
    
    // Receiving Addresses
    NSArray *addresses = [self buildReceivingAddresses];
    [self persistReceivingAddresses:addresses];
    
    // Transactions
    NSArray *transactions = [self buildTransactions];
    [self persistTransactions:transactions];
    
    // Synchronize everything.
    [self.defaults synchronize];
}

- (NSArray *)contacts
{
    NSData *contactsData = [self.defaults objectForKey:RDDContactsKey];
    NSArray *contacts = [NSKeyedUnarchiver unarchiveObjectWithData:contactsData];
    return contacts;
}

- (NSArray *)receivingAddresses
{
    NSData *addressesData = [self.defaults objectForKey:RDDReceivingAddressesKey];
    NSArray *addresses = [NSKeyedUnarchiver unarchiveObjectWithData:addressesData];
    return addresses;
}

- (NSArray *)transactions
{
    NSData *transactionsData = [self.defaults objectForKey:RDDTransactionsKey];
    NSArray *transactions = [NSKeyedUnarchiver unarchiveObjectWithData:transactionsData];
    return transactions;
}

- (void)addContact:(RDDContact *)contact
{
    NSMutableArray *contacts = [NSMutableArray arrayWithArray:[self contacts]];
    
    if ([contacts containsObject:contact]) {
        // Contact already exists. Update label if necessary.
        if (contact.label) {
            NSInteger index = [contacts indexOfObject:contact];
            RDDContact *existingContact = [contacts objectAtIndex:index];
            existingContact.label = contact.label;
        }
    } else {
        // Add new contact
        [contacts addObject:contact];
    }
    
    [self persistContacts:contacts];
}

- (void)addReceivingAddress:(RDDReceivingAddress *)address
{
    NSMutableArray *addresses = [NSMutableArray arrayWithArray:[self receivingAddresses]];
    [addresses addObject:address];
    [self persistReceivingAddresses:addresses];
}

- (void)addTransaction:(RDDTransaction *)transaction
{
    NSMutableArray *transactions = [NSMutableArray arrayWithArray:[self transactions]];
    [transactions addObject:transaction];
    [self persistTransactions:transactions];
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

- (void)persistContacts:(NSArray *)contacts
{
    NSData *contactsData = [NSKeyedArchiver archivedDataWithRootObject:contacts];
    [self.defaults setObject:contactsData forKey:RDDContactsKey];
}

- (void)persistReceivingAddresses:(NSArray *)addresses
{
    NSData *addressesData = [NSKeyedArchiver archivedDataWithRootObject:addresses];
    [self.defaults setObject:addressesData forKey:RDDReceivingAddressesKey];
}

- (void)persistTransactions:(NSArray *)transactions
{
    NSData *transactionsData = [NSKeyedArchiver archivedDataWithRootObject:transactions];
    [self.defaults setObject:transactionsData forKey:RDDTransactionsKey];
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
