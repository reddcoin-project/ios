//
//  RDDSeedViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 10/22/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDSeedViewController.h"

#import "BRWallet.h"
#import "RDDWalletManager.h"

@interface RDDSeedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *seedLabel;
@property (nonatomic, strong) NSString *seedPhrase;
@end

@implementation RDDSeedViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        RDDWalletManager *m = [RDDWalletManager sharedInstance];
        
        if ([[UIApplication sharedApplication] isProtectedDataAvailable] && ! m.wallet) {
            self.seedPhrase = [m generateRandomSeed];
//            [[BRPeerManager sharedInstance] connect];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WALLET_NEEDS_BACKUP_KEY];
//            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else self.seedPhrase = m.seedPhrase; // this triggers authentication request
        
        if (self.seedPhrase.length > 0) _authSuccess = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Seed phrase: \"%@\"", self.seedPhrase);
    
    @autoreleasepool {  // @autoreleasepool ensures sensitive data will be dealocated immediately
        self.seedLabel.text = self.seedPhrase;
        self.seedPhrase = nil;
    }
    
    [self generateReceiveAddress];
}

- (void)generateReceiveAddress
{
    RDDWalletManager *m = [RDDWalletManager sharedInstance];
    NSString *address = m.wallet.receiveAddress;
    NSLog(@"Receive Address: %@", address);
}

@end
