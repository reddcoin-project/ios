//
//  RDDConstants.h
//  Reddcoin
//
//  Created by Adam McDonald on 8/21/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const RDDCurrencyCode = @"RDD";
static NSString * const RDDQRCodeScheme = @"reddcoin";
static NSString * const RDDBlockExplorerBaseURL = @"http://bitinfocharts.com/reddcoin/tx/";

static const NSInteger RDDSeedEntropyLenth = (128/8);
static NSString * const RDDSecAttrService = @"com.reddcoin.reddcoin";

static NSString * const RDDMnemonicKey = @"mnemonic";
static NSString * const RDDCreationTimeKey = @"creationtime";
static NSString * const RDDMasterPubkeyKey = @"masterpubkey";
static NSString * const RDDPasscodeDetectKey = @"passcodedetect";

static NSString * const RDDTransactionSuccessfulNotification = @"RDDTransactionSuccessfulNotification";

@interface RDDConstants : NSObject
@end
