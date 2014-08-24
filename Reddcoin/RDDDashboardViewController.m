//
//  RDDDashboardViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/22/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDDashboardViewController.h"

#import "RDDConstants.h"
#import "RDDReddAPIManager.h"

@interface RDDDashboardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *confirmedBalanceTextField;
@property (weak, nonatomic) IBOutlet UILabel *pendingDepositsTextField;
@property (nonatomic, strong) RDDReddAPIManager *reddApi;
@end

@implementation RDDDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureReddAPI];
    [self loadUserBalanceDetail];
}

- (void)configureReddAPI
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.reddApi = [[RDDReddAPIManager alloc] initWithGetKey:[defaults stringForKey:kDefaultsReddAPIGETKey]
                                                     postKey:[defaults stringForKey:kDefaultsReddAPIPOSTKey]];
}

- (void)loadUserBalanceDetail
{
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultsReddAPIUsername];
    
    [self.reddApi getUserBalanceDetailForUsername:username
                                          success:^(NSDictionary *json) {
                                              [self parseUserBalanceDetailJSON:json];
                                          } failure:^(NSError *error) {
                                              [self showGenericAlert];
                                          }];
}

- (void)parseUserBalanceDetailJSON:(NSDictionary *)json
{
    NSLog(@"%@", json);
    self.confirmedBalanceTextField.text = [NSString stringWithFormat:@"%@", json[@"ConfirmedBalance"]];
    self.pendingDepositsTextField.text = [NSString stringWithFormat:@"%@", json[@"PendingDeposits"]];
}

- (void)showGenericAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Generic Error"
                                message:@"Something went wrong."
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}

@end
