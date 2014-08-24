//
//  RDDAuthenticationViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/22/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDAuthenticationViewController.h"

#import "RDDConstants.h"

@interface RDDAuthenticationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *getKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *postKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation RDDAuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self populateKeys];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentTabBarControllerSegue"]) {
        
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)populateKeys
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
    if (filePath) {
        NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        self.getKeyTextField.text = plist[@"ReddAPIGETKey"];
        self.postKeyTextField.text = plist[@"ReddAPIPOSTKey"];
        self.usernameTextField.text = plist[@"ReddAPIUsername"];
    }
}

- (void)storeKeys
{
    // TODO: store in the keychain
    
    NSString *getKey = self.getKeyTextField.text;
    NSString *postKey = self.postKeyTextField.text;
    NSString *username = self.usernameTextField.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:getKey forKey:kDefaultsReddAPIGETKey];
    [[NSUserDefaults standardUserDefaults] setObject:postKey forKey:kDefaultsReddAPIPOSTKey];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kDefaultsReddAPIUsername];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)tappedLogInButton:(id)sender
{
    NSString *getKey = self.getKeyTextField.text;
    NSString *postKey = self.postKeyTextField.text;
    NSString *username = self.usernameTextField.text;
    
    if ([getKey length] == 0 || [postKey length] == 0 || [username length] == 0) {
        [self showMissingInfoAlert];
        return;
    }
    
    [self storeKeys];
    
    [self performSegueWithIdentifier:@"presentTabBarControllerSegue" sender:self];
}

- (void)showMissingInfoAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Required Info"
                                message:@"You must enter both GET and POST API keys in addition to a username."
                               delegate:nil
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}

@end
