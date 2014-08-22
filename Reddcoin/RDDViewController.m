//
//  ViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/21/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDViewController.h"

#import "RDDConstants.h"
#import "RDDReddAPIManager.h"

@interface RDDViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (nonatomic, strong) RDDReddAPIManager *reddApi;
@end

@implementation RDDViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    self.reddApi = [[RDDReddAPIManager alloc] initWithGetKey:plist[@"ReddAPIGETKey"] postKey:plist[@"ReddAPIPOSTKey"]];
}

- (IBAction)tappedGetUserInfoButton:(id)sender
{
    self.outputLabel.text = @"";
    
    NSString *username = self.usernameTextField.text;
    [self.reddApi getUserInfoForUsername:username
                                 success:^(NSDictionary *json) {
                                     [self parseGetUserInfoJSON:json];
                                 } failure:^(NSError *error) {
                                     NSLog(@"%@", [error localizedDescription]);
                                     [self showGenericAlert];
                                 }];
}

- (IBAction)tappedGetUserBalanceDetailButton:(id)sender
{
    self.outputLabel.text = @"";
    
    NSString *username = self.usernameTextField.text;
    [self.reddApi getUserBalanceDetailForUsername:username
                                          success:^(NSDictionary *json) {
                                              [self parseGetUserBalanceDetailJSON:json];
                                          } failure:^(NSError *error) {
                                              NSLog(@"%@", [error localizedDescription]);
                                              [self showGenericAlert];
                                          }];
}

- (void)parseGetUserInfoJSON:(NSDictionary *)json
{
    NSLog(@"%@", json);
    self.outputLabel.text = [NSString stringWithFormat:@"Deposit Address:\n%@", json[@"DepositAddress"]];
}

- (void)parseGetUserBalanceDetailJSON:(NSDictionary *)json
{
    NSLog(@"%@", json);
    self.outputLabel.text = [NSString stringWithFormat:@"Confirmed Balance:\n%@ RDD", json[@"ConfirmedBalance"]];
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
