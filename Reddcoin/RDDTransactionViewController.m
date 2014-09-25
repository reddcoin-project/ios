//
//  RDDTransactionViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/17/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDTransactionViewController.h"

#import "RDDColor.h"
#import "RDDConstants.h"
#import "RDDQTExportParser.h"
#import "RDDStringFormatter.h"
#import "RDDTransaction.h"

#define ROW_ID      0
#define ROW_DATE    1
#define ROW_STATUS  2
#define ROW_AMOUNT  3
#define ROW_ADDRESS 4

@interface RDDTransactionViewController ()

@end

@implementation RDDTransactionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [RDDColor backgroundColor];
    }
    
    NSString *textString = @"";
    NSString *detailString = @"";
    
    switch (row) {
        case ROW_ID:
        {
            textString = @"ID:";
            detailString = self.transaction.transactionID;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            break;
        }
        case ROW_DATE:
            textString = @"Date:";
            detailString = self.transaction.dateString;
            break;
        case ROW_STATUS:
            textString = @"Status:";
            detailString = @"x confirmations";
            break;
        case ROW_AMOUNT:
        {
            textString = @"Amount:";
            detailString = [RDDStringFormatter formatAmount:self.transaction.amount includeCurrencyCode:NO];
            break;
        }
        case ROW_ADDRESS:
            textString = @"Address:";
            detailString = self.transaction.address;
            break;
        default:
            break;
    }
    
    cell.textLabel.text = textString;
    cell.detailTextLabel.text = detailString;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *urlString = [kReddcoinBlockExplorerBaseURL stringByAppendingString:self.transaction.transactionID];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

@end
