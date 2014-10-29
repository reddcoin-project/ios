//
//  RDDWalletManager.m
//  Reddcoin
//
//  Created by Adam McDonald on 10/23/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDWalletManager.h"

#import "BRBIP32Sequence.h"
#import "BRBIP39Mnemonic.h"
#import "BRKey.h"
#import "BRWallet.h"
#import "NSMutableData+Bitcoin.h"
#import "NSString+Base58.h"
#import "RDDConstants.h"

static BOOL isPasscodeEnabled()
{
    NSDictionary *query = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService:RDDSecAttrService,
                            (__bridge id)kSecAttrAccount:RDDPasscodeDetectKey};
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)query, nil) != errSecItemNotFound) return YES;
    
    NSDictionary *item = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                           (__bridge id)kSecAttrService:RDDSecAttrService,
                           (__bridge id)kSecAttrAccount:RDDPasscodeDetectKey,
                           (__bridge id)kSecAttrAccessible:(__bridge id)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                           (__bridge id)kSecValueData:[NSData data]};
    
    return (SecItemAdd((__bridge CFDictionaryRef)item, NULL) != errSecDecode) ? YES : NO;
}

static BOOL setKeychainData(NSData *data, NSString *key, BOOL authenticated)
{
    if (! key) return NO;
    
    CFErrorRef error = NULL;
    SecAccessControlRef access = (data) ?
    SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                    (authenticated) ? kSecAttrAccessibleWhenUnlockedThisDeviceOnly :
                                    kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
                                    (authenticated) ? kSecAccessControlUserPresence : 0, &error) : NULL;
    NSDictionary *query = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService:RDDSecAttrService,
                            (__bridge id)kSecAttrAccount:key};
    
    if (data && (access == NULL || error)) {
#if DEBUG
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"SecAccessControlRef: %@", error]
                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
#endif
        NSLog(@"SecAccessControlRef: %@", error);
        return NO;
    }
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL) == errSecItemNotFound) {
        if (! data) return YES;
        
        NSDictionary *item = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                               (__bridge id)kSecAttrService:RDDSecAttrService,
                               (__bridge id)kSecAttrAccount:key,
                               (__bridge id)kSecAttrAccessControl:(__bridge_transfer id)access,
                               (__bridge id)kSecValueData:data};
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)item, NULL);
        
        if (status == noErr) return YES;
        NSLog(@"SecItemAdd error status %d", (int)status);
#if DEBUG
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:[NSString stringWithFormat:@"SecItemAdd error status %d", (int)status] delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
#endif
        return NO;
    }
    
    if (! data) {
        OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
        
        if (status == noErr) return YES;
        NSLog(@"SecItemDelete error status %d", (int)status);
#if DEBUG
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:[NSString stringWithFormat:@"SecItemDelete error status %d", (int)status] delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
#endif
        return NO;
    }
    
    NSDictionary *update = @{(__bridge id)kSecAttrAccessControl:(__bridge_transfer id)access,
                             (__bridge id)kSecValueData:data};
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
    
    if (status == noErr) return YES;
    NSLog(@"SecItemUpdate error status %d", (int)status);
#if DEBUG
    [[[UIAlertView alloc] initWithTitle:nil
                                message:[NSString stringWithFormat:@"SecItemUpdate error status %d", (int)status] delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
#endif
    return NO;
}

static NSData *getKeychainData(NSString *key, NSString *authprompt)
{
    NSDictionary *query = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService:RDDSecAttrService,
                            (__bridge id)kSecAttrAccount:key,
                            (__bridge id)kSecReturnData:@YES,
                            (__bridge id)kSecUseOperationPrompt:(authprompt) ? authprompt : @""};
    CFDataRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    
    if (status == errSecItemNotFound) return nil;
    if (status == noErr) return CFBridgingRelease(result);
    
    if (status == errSecAuthFailed && ! isPasscodeEnabled()) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"turn device passcode on", nil)
                                    message:NSLocalizedString(@"\ngo to settings and turn passcode on to access restricted areas of your wallet",
                                                              nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil)
                          otherButtonTitles:nil] show];
    }
#if DEBUG
    else if (status != errSecAuthFailed) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:[NSString stringWithFormat:@"SecItemCopyMatching error status %d", (int)status] delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil] show];
    }
#endif
    
    NSLog(@"SecItemCopyMatching error status %d", (int)status);
    return nil;
}

@interface RDDWalletManager()
@property (nonatomic, strong) BRWallet *wallet;
@property (nonatomic, strong) id<BRKeySequence> sequence;
@end

@implementation RDDWalletManager

+ (instancetype)sharedInstance
{
    static RDDWalletManager *_manager;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BRWallet *)wallet
{
    if (_wallet || ! [[UIApplication sharedApplication] isProtectedDataAvailable]) return _wallet;
    
//    if (getKeychainData(SEED_KEY, nil)) { // upgrade from old non-authenticated keychain
//        NSLog(@"upgrading to authenticated keychain scheme");
//        setKeychainData([self.sequence masterPublicKeyFromSeed:self.seed], MASTER_PUBKEY_KEY, NO);
//        self.didAuthenticate = NO;
//        
//        if (setKeychainData(getKeychainData(MNEMONIC_KEY, nil), MNEMONIC_KEY, YES)) {
//            setKeychainData(nil, SEED_KEY, NO);
//            setKeychainData(nil, PIN_KEY, NO);
//            setKeychainData(nil, PIN_FAIL_COUNT_KEY, NO);
//            setKeychainData(nil, PIN_FAIL_HEIGHT_KEY, NO);
//        }
//        else if (! self.passcodeEnabled) return nil;
//    }
    
    if (! self.masterPublicKey) return _wallet;
    
    @synchronized(self) {
        if (_wallet) return _wallet;
        
//        _wallet = [[BRWallet alloc] initWithContext:[NSManagedObject context] sequence:self.sequence
//                                    masterPublicKey:self.masterPublicKey seed:^NSData *{ return self.seed; }];
        _wallet = [[BRWallet alloc] initWithSequence:self.sequence
                                     masterPublicKey:self.masterPublicKey
                                                seed:^NSData *{ return self.seed; }];
        
        // verify that keychain matches core data, with different access and backup policies it's possible to diverge
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BRKey *k = [BRKey keyWithPublicKey:[self.sequence publicKey:0 internal:NO
                                                        masterPublicKey:self.masterPublicKey]];
            
            if (_wallet.addresses.count > 0 && ! [_wallet containsAddress:k.address]) {
#if DEBUG
                abort(); // don't wipe core data for debug builds
#endif
//                [[NSManagedObject context] performBlockAndWait:^{
//                    [BRAddressEntity deleteObjects:[BRAddressEntity allObjects]];
//                    [BRTransactionEntity deleteObjects:[BRTransactionEntity allObjects]];
//                    [NSManagedObject saveContext];
//                }];
                
                _wallet = nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:BRWalletManagerSeedChangedNotification
                                                                        object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:BRWalletBalanceChangedNotification
                                                                        object:nil];
                });
            }
        });
        
        return _wallet;
    }
}

- (id<BRKeySequence>)sequence
{
    if (! _sequence) _sequence = [BRBIP32Sequence new];
    return _sequence;
}

// master public key used to generate wallet addresses
- (NSData *)masterPublicKey
{
    return getKeychainData(RDDMasterPubkeyKey, nil);
}

// requesting seed will trigger authentication
- (NSData *)seed
{
    return [self seedWithPrompt:nil];
}

- (NSString *)seedPhrase
{
    return [self seedPhraseWithPrompt:nil];
}

- (void)setSeedPhrase:(NSString *)seedPhrase
{
    @autoreleasepool { // @autoreleasepool ensures sensitive data will be dealocated immediately
        BRBIP39Mnemonic *m = [BRBIP39Mnemonic sharedInstance];
        
        if (seedPhrase) seedPhrase = [m encodePhrase:[m decodePhrase:seedPhrase]];
        
//        [[NSManagedObject context] performBlockAndWait:^{
//            [BRAddressEntity deleteObjects:[BRAddressEntity allObjects]];
//            [BRTransactionEntity deleteObjects:[BRTransactionEntity allObjects]];
//            [NSManagedObject saveContext];
//        }];
        
        setKeychainData(nil, RDDCreationTimeKey, NO);
        setKeychainData(nil, RDDMasterPubkeyKey, NO);
        
        NSData *mnemonic = (seedPhrase) ?
        CFBridgingRelease(CFStringCreateExternalRepresentation(SecureAllocator(),
                                                               (CFStringRef)seedPhrase,
                                                               kCFStringEncodingUTF8, 0)) : nil,
        *masterPubKey = (seedPhrase) ?
        [self.sequence
         masterPublicKeyFromSeed:[m deriveKeyFromPhrase:seedPhrase withPassphrase:nil]] : nil;
        
        if (! setKeychainData(mnemonic, RDDMnemonicKey, YES)) {
            NSLog(@"error setting wallet seed");
            
            if (seedPhrase) {
                [[[UIAlertView alloc] initWithTitle:@"couldn't create wallet"
                                            message:@"error adding master private key to iOS keychain, make sure app has keychain entitlements"
                                           delegate:self cancelButtonTitle:@"abort" otherButtonTitles:nil] show];
            }
            
            return;
        }
        
        setKeychainData(masterPubKey, RDDMasterPubkeyKey, NO);
        _wallet = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BRWalletManagerSeedChangedNotification object:nil];
    });
}

// true if device passcode is enabled
- (BOOL)isPasscodeEnabled
{
    return isPasscodeEnabled();
}

- (NSString *)generateRandomSeed
{
    @autoreleasepool {
        NSMutableData *entropy = [NSMutableData secureDataWithLength:RDDSeedEntropyLenth];
        NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
        
        SecRandomCopyBytes(kSecRandomDefault, entropy.length, entropy.mutableBytes);
        
        NSString *phrase = [[BRBIP39Mnemonic sharedInstance] encodePhrase:entropy];
        
        self.seedPhrase = phrase;
        
        // we store the wallet creation time on the keychain because keychain data persists even when an app is deleted
        setKeychainData([NSData dataWithBytes:&time length:sizeof(time)], RDDCreationTimeKey, NO);
        
        return phrase;
    }
}

// authenticates user and returns seed
- (NSData *)seedWithPrompt:(NSString *)authprompt
{
    @autoreleasepool {
        BRBIP39Mnemonic *m = [BRBIP39Mnemonic sharedInstance];
        NSString *phrase = [self seedPhraseWithPrompt:authprompt];
        
        if (phrase.length == 0) return nil;
        return [m deriveKeyFromPhrase:phrase withPassphrase:nil];
    }
}

- (NSString *)seedPhraseWithPrompt:(NSString *)authprompt
{
    @autoreleasepool {
        NSData *phrase = getKeychainData(RDDMnemonicKey, authprompt);
        
        if (! phrase) return nil;
        
        self.didAuthenticate = YES;
        return CFBridgingRelease(CFStringCreateFromExternalRepresentation(SecureAllocator(), (CFDataRef)phrase,
                                                                          kCFStringEncodingUTF8));
    }
}

// prompts user to authenticate with touch id or passcode
- (BOOL)authenticateWithPrompt:(NSString *)authprompt
{
    @autoreleasepool {
        if (! getKeychainData(RDDMnemonicKey, authprompt)) return NO;
        self.didAuthenticate = YES;
        return YES;
    }
}

@end
