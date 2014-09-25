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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addresses count];
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
    
    RDDReceivingAddress *address = self.addresses[row];
    
    cell.textLabel.text = address.label;
    cell.detailTextLabel.text = address.address;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
