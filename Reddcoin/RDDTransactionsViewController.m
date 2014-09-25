//
//  RDDTransactionsViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/22/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDTransactionsViewController.h"

#import "RDDColor.h"
#import "RDDConstants.h"
#import "RDDQTExportParser.h"
#import "RDDSeedData.h"
#import "RDDStringFormatter.h"
#import "RDDTransaction.h"
#import "RDDTransactionViewController.h"

@interface RDDTransactionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *transactions;
@end

@implementation RDDTransactionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTransactionData];
}

- (void)loadTransactionData
{
    self.transactions = [[[RDDSeedData alloc] init] transactions];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowTransaction"]) {
        RDDTransactionViewController *vc = (RDDTransactionViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RDDTransaction *transaction = self.transactions[indexPath.row];
        vc.transaction = transaction;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transactions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = @"TransactionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    RDDTransaction *transaction = self.transactions[row];
    NSString *confirmedString = transaction.confirmed ? @"Confirmed" : @"Unconfirmed";
    NSString *amountStr = [RDDStringFormatter formatAmount:transaction.amount includeCurrencyCode:NO];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", confirmedString, amountStr];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", transaction.dateString, transaction.type, transaction.label];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

@end
