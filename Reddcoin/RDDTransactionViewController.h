//
//  RDDTransactionViewController.h
//  Reddcoin
//
//  Created by Adam McDonald on 9/17/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDDTransaction;

@interface RDDTransactionViewController : UIViewController
@property (nonatomic, strong) RDDTransaction *transaction;
@end
