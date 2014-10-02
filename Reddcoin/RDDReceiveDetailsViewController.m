//
//  RDDReceiveDetailsViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 10/1/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDReceiveDetailsViewController.h"

#import "RDDAddressQRTableViewCell.h"
#import "RDDReceivingAddress.h"

@interface RDDReceiveDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RDDReceiveDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row <= 1) ? 44.0 : 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row <= 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveDetailsCellIdentifier"];
        if (row == 0) {
            // Row 0: Label
            cell.textLabel.text = @"Label:";
            cell.detailTextLabel.text = self.address.label;
        } else {
            // Row 1: Address
            cell.textLabel.text = @"Address:";
            cell.detailTextLabel.text = self.address.address;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        }
        return cell;
    } else {
        // Row 2: QR Code
        RDDAddressQRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveDetailsQRCellIdentifier"];
        cell.receivingAddress = self.address;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row <= 1);
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        [UIPasteboard generalPasteboard].string = cell.detailTextLabel.text;
    }
}

@end
