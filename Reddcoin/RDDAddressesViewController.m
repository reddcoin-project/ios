//
//  RDDAddressesViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDAddressesViewController.h"

#import "RDDConstants.h"

@interface RDDAddressesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *users;
@end

@implementation RDDAddressesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAddressData];
}

- (void)loadAddressData
{

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = @"ReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *user = self.users[row];
    cell.textLabel.text = user[@"Username"];
    cell.detailTextLabel.text = user[@"DepositAddress"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
}

@end
