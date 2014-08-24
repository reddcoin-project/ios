//
//  RDDSendViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDSendViewController.h"

#import "RDDConstants.h"
#import "RDDReddAPIManager.h"

@interface RDDSendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) RDDReddAPIManager *reddApi;
@end

@implementation RDDSendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureReddAPI];
}

- (void)configureReddAPI
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.reddApi = [[RDDReddAPIManager alloc] initWithGetKey:[defaults stringForKey:kDefaultsReddAPIGETKey]
                                                     postKey:[defaults stringForKey:kDefaultsReddAPIPOSTKey]];
}

- (void)setInterfaceEnabled:(BOOL)enabled
{
    self.addressTextField.enabled = enabled;
    self.usernameTextField.enabled = enabled;
    self.amountTextField.enabled = enabled;
    self.sendButton.enabled = enabled;
}

- (IBAction)tappedSendButton:(id)sender
{
    [self setInterfaceEnabled:NO];
    
    NSString *address = self.addressTextField.text;
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *username = self.usernameTextField.text;
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *amountString = self.amountTextField.text;
    amountString = [amountString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([amountString length] == 0) {
        [self showAmountAlert];
        [self setInterfaceEnabled:YES];
        return;
    }
    
    NSNumber *amount = [NSNumber numberWithFloat:[amountString floatValue]];
    
    if ([address length] > 0) {
        // Send to address
        [self sendAmount:amount toAddress:address];
    } else if ([username length] > 0) {
        // Send to username
        [self sendAmount:amount toUsername:username];
    } else {
        // No address or username
        [self showRecipientAlert];
        [self setInterfaceEnabled:YES];
    }
}

- (void)sendAmount:(NSNumber *)amount toAddress:(NSString *)address
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authenticatedUsername = [defaults stringForKey:kDefaultsReddAPIUsername];
    
    [self.reddApi sendFromUsername:authenticatedUsername
                         toAddress:address
                            amount:amount
                           success:^(NSDictionary *json) {
                               [self parseSendToAddressJSON:json];
                               [self setInterfaceEnabled:YES];
                           } failure:^(NSError *error) {
                               [self showGenericAlert];
                               [self setInterfaceEnabled:YES];
                           }];
}

- (void)sendAmount:(NSNumber *)amount toUsername:(NSString *)username
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authenticatedUsername = [defaults stringForKey:kDefaultsReddAPIUsername];
    
    [self.reddApi sendFromUsername:authenticatedUsername
                        toUsername:username
                            amount:amount
                           success:^(NSDictionary *json) {
                               [self parseSendToUsernameJSON:json];
                               [self setInterfaceEnabled:YES];
                           } failure:^(NSError *error) {
                               [self showGenericAlert];
                               [self setInterfaceEnabled:YES];
                           }];
}

- (void)parseSendToAddressJSON:(NSDictionary *)json
{
    [self showSentAlert];
    [self clearFields];
}

- (void)parseSendToUsernameJSON:(NSDictionary *)json
{
    /// TODO: HACK around invalid ReddAPI response (returns only "Success" string)
    [self showSentAlert];
    [self clearFields];
    return;
    /// TODO: HACK
    
    /*
    NSString *status = json[@"status"];
    if ([status isEqualToString:@"success"]) {
        // Send successful
        [self showSentAlert];
        [self clearFields];
    } else {
        // Send failed
        
        // TODO: handle different error cases
        
        [self showGenericAlert];
    }
    */
}

- (void)showAmountAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Send Error"
                                message:@"A valid amount is required."
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}

- (void)showRecipientAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Send Error"
                                message:@"A Reddcoin address or ReddAPI username is required."
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}

- (void)showGenericAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Generic Error"
                                message:@"Something went wrong."
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}

- (void)showSentAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Sent"
                                message:@"Reddcoin transaction successful!"
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}

- (void)clearFields
{
    self.addressTextField.text = @"";
    self.usernameTextField.text = @"";
    self.amountTextField.text = @"";
}

@end
