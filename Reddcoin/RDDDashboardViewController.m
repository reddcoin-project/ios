//
//  RDDDashboardViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/22/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDDashboardViewController.h"

#import "RDDConstants.h"
#import "RDDStringFormatter.h"

@interface RDDDashboardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stakeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

@end

@implementation RDDDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDashboardData];
}

- (void)loadDashboardData
{
    NSNumber *balance = @(arc4random_uniform(10000000));
    NSNumber *stake = @(arc4random_uniform(1000));
    NSNumber *total = @([balance intValue] + [stake intValue]);
    
    self.balanceValueLabel.text = [RDDStringFormatter formatAmount:balance includeCurrencyCode:YES];
    self.stakeValueLabel.text = [RDDStringFormatter formatAmount:stake includeCurrencyCode:YES];
    self.totalValueLabel.text = [RDDStringFormatter formatAmount:total includeCurrencyCode:YES];
}

@end
