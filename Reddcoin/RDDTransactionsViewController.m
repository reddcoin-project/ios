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
#import "RDDStringFormatter.h"

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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transactions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = @"ReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [RDDColor backgroundColor];
    }
    
    NSDictionary *transaction = self.transactions[row];
    NSString *confirmedString = [transaction[@"Confirmed"] boolValue] ? @"Confirmed" : @"Unconfirmed";
    
    NSNumber *amount;
    if ([transaction[@"Amount"] isKindOfClass:[NSNumber class]]) {
        // 124.123
        amount = transaction[@"Amount"];
    } else {
        // "1 234.123"
        NSString *str = transaction[@"Amount"];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        amount = @([str floatValue]);
    }
    
    NSString *amountStr = [RDDStringFormatter formatAmount:amount includeCurrencyCode:NO];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", confirmedString, amountStr];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", transaction[@"Date"], transaction[@"Type"], transaction[@"Label"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
