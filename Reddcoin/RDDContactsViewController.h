//
//  RDDAddressesViewController.h
//  Reddcoin
//
//  Created by Adam McDonald on 8/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDDContact, RDDContactsViewController;

@protocol RDDContactsViewControllerDelegate <NSObject>
- (void)rddContactsViewController:(RDDContactsViewController *)controller didSelectContact:(RDDContact *)contact;
@end

@interface RDDContactsViewController : UIViewController
@property (nonatomic, weak) NSObject<RDDContactsViewControllerDelegate> *delegate;
@end