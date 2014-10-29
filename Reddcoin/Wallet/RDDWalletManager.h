//
//  RDDWalletManager.h
//  Reddcoin
//
//  Created by Adam McDonald on 10/23/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BRWalletManagerSeedChangedNotification @"BRWalletManagerSeedChangedNotification"

@class BRWallet;
@protocol BRKeySequence;

@interface RDDWalletManager : NSObject
@property (nonatomic, readonly) BRWallet *wallet;
@property (nonatomic, readonly) id<BRKeySequence> sequence;
@property (nonatomic, readonly) NSData *masterPublicKey; // master public key used to generate wallet addresses
@property (nonatomic, readonly) NSData *seed; // requesting seed will trigger authentication
@property (nonatomic, copy) NSString *seedPhrase; // requesting seedPhrase will trigger authentication
@property (nonatomic, readonly, getter=isPasscodeEnabled) BOOL passcodeEnabled; // true if device passcode is enabled
@property (nonatomic, assign) BOOL didAuthenticate; // true if the user authenticated after this was last set to false

+ (instancetype)sharedInstance;
- (NSString *)generateRandomSeed;
- (NSString *)seedPhraseWithPrompt:(NSString *)authprompt; // authenticates user and returns seedPhrase
- (NSData *)seedWithPrompt:(NSString *)authprompt; // authenticates user and returns seed
- (BOOL)authenticateWithPrompt:(NSString *)authprompt; // prompts user to authenticate with touch id or passcode
@end
