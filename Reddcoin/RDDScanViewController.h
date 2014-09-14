//
//  RDDScanViewController.h
//  Reddcoin
//
//  Created by Adam McDonald on 9/13/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDDScanViewController;

@protocol RDDScanViewControllerDelegate <NSObject>
- (void)rddScanViewController:(RDDScanViewController *)controller didScan:(NSString *)value;
@end

@interface RDDScanViewController : UIViewController
@property (nonatomic, weak) NSObject<RDDScanViewControllerDelegate> *delegate;
@end
