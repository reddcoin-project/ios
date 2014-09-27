//
//  RDDAddressesViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDContactsViewController.h"

#import "RDDConstants.h"
#import "RDDContact.h"
#import "RDDSeedData.h"

@interface RDDContactsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *contacts;
@end

@implementation RDDContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadContactsData];
}

- (void)loadContactsData
{
    self.contacts = [[[RDDSeedData alloc] init] contacts];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = @"ReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    RDDContact *contact = self.contacts[row];
    cell.textLabel.text = contact.label;
    cell.detailTextLabel.text = contact.address;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RDDContact *contact = self.contacts[indexPath.row];
    [self.delegate rddContactsViewController:self didSelectContact:contact];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
