//
//  RDDQRCodeParser.h
//  Reddcoin
//
//  Created by Adam McDonald on 9/13/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDDQRCodeParser : NSObject
+ (NSDictionary *)parse:(NSString *)scannedValue;
@end
