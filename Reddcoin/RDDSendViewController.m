//
//  RDDSendViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDSendViewController.h"

#import "RDDConstants.h"

@interface RDDSendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@end

@implementation RDDSendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setInterfaceEnabled:(BOOL)enabled
{
    self.addressTextField.enabled = enabled;
    self.amountTextField.enabled = enabled;
    self.sendButton.enabled = enabled;
}

- (IBAction)tappedSendButton:(id)sender
{
    [self setInterfaceEnabled:NO];
    
    NSString *address = self.addressTextField.text;
    address = [address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *amountString = self.amountTextField.text;
    amountString = [amountString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([amountString length] == 0) {
        [self showAmountAlert];
        [self setInterfaceEnabled:YES];
        return;
    }
    
    NSNumber *amount = [NSNumber numberWithFloat:[amountString floatValue]];
    
    // TODO: Send
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

- (void)clearFields
{
    self.addressTextField.text = @"";
    self.amountTextField.text = @"";
}

@end
