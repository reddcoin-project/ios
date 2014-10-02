//
//  RDDReceiveDetailsViewController.h
//  Reddcoin
//
//  Created by Adam McDonald on 10/1/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDDReceivingAddress;

@interface RDDReceiveDetailsViewController : UIViewController
@property (strong, nonatomic) RDDReceivingAddress *address;
@end
