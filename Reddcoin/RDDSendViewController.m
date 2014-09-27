//
//  RDDSendViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDSendViewController.h"

#import "RDDConstants.h"
#import "RDDContact.h"
#import "RDDContactsViewController.h"
#import "RDDElectrumClient.h"
#import "RDDQRCodeParser.h"
#import "RDDScanViewController.h"
#import "RDDSeedData.h"
#import "RDDStringFormatter.h"

@interface RDDSendViewController () <RDDContactsViewControllerDelegate, RDDScanViewControllerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) RDDElectrumClient *electrum;
@property (strong, nonatomic) RDDContact *contact;

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *labelTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *contactsButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@end

@implementation RDDSendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.electrum = [[RDDElectrumClient alloc] init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PresentScan"]) {
        RDDScanViewController *vc = (RDDScanViewController *)segue.destinationViewController;
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"ShowContacts"]) {
        RDDContactsViewController *vc = (RDDContactsViewController *)segue.destinationViewController;
        vc.delegate = self;
    }
}

- (void)setInterfaceEnabled:(BOOL)enabled
{
    self.addressTextField.enabled = enabled;
    self.labelTextField.enabled = enabled;
    self.amountTextField.enabled = enabled;
    self.scanButton.enabled = enabled;
    self.contactsButton.enabled = enabled;
    self.sendButton.enabled = enabled;
}

- (void)updateInterfaceWithContact:(RDDContact *)contact
{
    [self clearFields];
    self.addressTextField.text = contact.address;
    self.labelTextField.text = contact.label;
}

- (IBAction)tappedSendButton:(id)sender
{
    [self setInterfaceEnabled:NO];
    
    // Validate address
    NSString *address = [self sanitizedAddress];
    if (address == nil) {
        [self showRecipientAlert];
        [self setInterfaceEnabled:YES];
        return;
    }
    
    // Validate amount
    NSNumber *amount = [self sanitizedAmount];
    if (amount == nil) {
        [self showAmountAlert];
        [self setInterfaceEnabled:YES];
        return;
    }
    
    // Confirm send
    [self showSendConfirmationAlert];
}

- (NSString *)sanitizedAddress
{
    NSString *address = self.addressTextField.text;
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return ([address length] == 0) ? nil : address;
}

- (NSString *)sanitizedLabel
{
    NSString *label = self.labelTextField.text;
    label = [label stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return ([label length] == 0) ? nil : label;
}

- (NSNumber *)sanitizedAmount
{
    NSString *amountString = self.amountTextField.text;
    amountString = [amountString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([amountString length] == 0) {
        return nil;
    } else {
        return [NSNumber numberWithDouble:[amountString doubleValue]];
    }
}

- (void)showSendConfirmationAlert
{
    NSString *amountStr = [RDDStringFormatter formatAmount:[self sanitizedAmount] includeCurrencyCode:YES];
    NSString *msg = [NSString stringWithFormat:@"Are you sure you want to send %@ to %@?", amountStr, [self sanitizedAddress]];
    
    [[[UIAlertView alloc] initWithTitle:@"Send Reddcoins"
                                message:msg
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Yes", nil] show];
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
                                message:@"A Reddcoin address is required."
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

- (void)showSendErrorAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Send Error"
                                message:@"Reddcoin transaction failed."
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}

- (void)clearFields
{
    self.addressTextField.text = @"";
    self.labelTextField.text = @"";
    self.amountTextField.text = @"";
}

- (void)send
{
    NSString *address = [self sanitizedAddress];
    NSNumber *amount = [self sanitizedAmount];
    
    [self.electrum sendAmount:amount
                    toAddress:address
                      success:^{
                          [self saveContact];
                          [self clearFields];
                          [self setInterfaceEnabled:YES];
                          [self showSentAlert];
                      } failure:^(NSError *error) {
                          [self setInterfaceEnabled:YES];
                          [self showSendErrorAlert];
                      }];
}

- (void)saveContact
{
    RDDSeedData *seed = [[RDDSeedData alloc] init];
    
    // Save a new (or update) contact
    RDDContact *contact = [[RDDContact alloc] init];
    contact.address = [self sanitizedAddress];
    contact.label = [self sanitizedLabel];
    
    [seed addContact:contact];
    
    // Reset selected contact
    self.contact = nil;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Cancel
        [self setInterfaceEnabled:YES];
    } else {
        // Yes
        [self send];
    }
}

#pragma mark - RDDScanViewControllerDelegate

- (void)rddScanViewController:(RDDScanViewController *)controller didScan:(NSString *)value
{
    NSLog(@"rddScanViewController:didScan: %@", value);
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    NSDictionary *scanned = [RDDQRCodeParser parse:value];
    if (scanned) {
        self.addressTextField.text = scanned[@"address"];
        
        if (scanned[@"message"]) {
            self.labelTextField.text = scanned[@"message"];
        }
        
        if (scanned[@"amount"]) {
            self.amountTextField.text = scanned[@"amount"];
        }
    }
}

#pragma mark - RDDContactsViewControllerDelegate

- (void)rddContactsViewController:(RDDContactsViewController *)controller didSelectContact:(RDDContact *)contact
{
    NSLog(@"rddContactsViewController:didSelectContact: %@", contact.label);
    self.contact = contact;
    [self updateInterfaceWithContact:contact];
}

@end
