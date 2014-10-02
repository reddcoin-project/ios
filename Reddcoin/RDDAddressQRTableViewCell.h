//
//  RDDAddressQRTableViewCell.h
//  Reddcoin
//
//  Created by Adam McDonald on 10/2/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDDReceivingAddress;

@interface RDDAddressQRTableViewCell : UITableViewCell
@property (strong, nonatomic) RDDReceivingAddress *receivingAddress;
@end
