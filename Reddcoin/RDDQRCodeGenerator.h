//
//  RDDQRCodeGenerator.h
//  Reddcoin
//
//  Created by Adam McDonald on 10/2/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RDDQRCodeGenerator : NSObject
- (UIImage *)qrCodeImageForString:(NSString *)string withScale:(CGFloat)scale;
@end
