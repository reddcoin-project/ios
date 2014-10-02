//
//  RDDReceiveViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDReceiveViewController.h"

#import "RDDColor.h"
#import "RDDReceivingAddress.h"
#import "RDDReceiveDetailsViewController.h"
#import "RDDSeedData.h"

@interface RDDReceiveViewController ()
@property (strong, nonatomic) NSArray *addresses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RDDReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadReceivingAddressesData];
}

- (void)loadReceivingAddressesData
{
    self.addresses = [[[RDDSeedData alloc] init] receivingAddresses];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowReceiveDetails"]) {
        RDDReceiveDetailsViewController *vc = (RDDReceiveDetailsViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RDDReceivingAddress *address = self.addresses[indexPath.row];
        vc.address = address;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addresses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    RDDReceivingAddress *address = self.addresses[row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveCellIdentifier"];
    cell.textLabel.text = address.label;
    cell.detailTextLabel.text = address.address;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

@end
