//
//  RDDNewContactViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 9/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDNewContactViewController.h"

#import "RDDContact.h"
#import "RDDSeedData.h"

@interface RDDNewContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *labelField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@end

@implementation RDDNewContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)tappedAddButton:(id)sender
{
    NSLog(@"tappedAddButton:");
    
    NSString *label = self.labelField.text;
    NSString *address = self.addressField.text;
    
    // TODO: Validate address syntax
    
    if (label && [label length] > 0 && address && [address length] > 0) {
        RDDContact *contact = [[RDDContact alloc] init];
        contact.address = address;
        contact.label = label;
        
        RDDSeedData *seed = [[RDDSeedData alloc] init];
        [seed addContact:contact];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showAddErrorAlert];
    }
}

- (void)showAddErrorAlert
{
    [[[UIAlertView alloc] initWithTitle:@"New Contact"
                                message:@"Both label and address are required."
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}

@end
