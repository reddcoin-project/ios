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
#import "RDDStringFormatter.h"
#import "RDDTransactionViewController.h"

@interface RDDTransactionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *transactions;
@end

@implementation RDDTransactionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadTransactionData];
}

- (void)loadTransactionData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"reddcoin-transactions" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.transactions = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowTransaction"]) {
        RDDTransactionViewController *vc = (RDDTransactionViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *transaction = self.transactions[indexPath.row];
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
    
    NSDictionary *transaction = self.transactions[row];
    NSString *confirmedString = [transaction[@"Confirmed"] boolValue] ? @"Confirmed" : @"Unconfirmed";
    
    NSNumber *amount = [RDDQTExportParser parseAmount:transaction[@"Amount"]];
    NSString *amountStr = [RDDStringFormatter formatAmount:amount includeCurrencyCode:NO];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", confirmedString, amountStr];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", transaction[@"Date"], transaction[@"Type"], transaction[@"Label"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

@end
