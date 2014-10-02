//
//  RDDAddressQRTableViewCell.m
//  Reddcoin
//
//  Created by Adam McDonald on 10/2/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDAddressQRTableViewCell.h"

#import "RDDQRCode.h"
#import "RDDQRCodeGenerator.h"

@interface RDDAddressQRTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@end

@implementation RDDAddressQRTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setReceivingAddress:(RDDReceivingAddress *)receivingAddress
{
    _receivingAddress = receivingAddress;
    
    RDDQRCodeGenerator *generator = [[RDDQRCodeGenerator alloc] init];
    
    NSString *str = [RDDQRCode generate:receivingAddress];
    CGFloat scale = (2 * [[UIScreen mainScreen] scale]);
    
    UIImage *qrImage = [generator qrCodeImageForString:str withScale:scale];
    self.qrImageView.image = qrImage;
}

@end
