//
//  RDDTransactionsViewController.m
//  Reddcoin
//
//  Created by Adam McDonald on 8/22/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import "RDDTransactionsViewController.h"

#import "RDDConstants.h"
#import "RDDReddAPIManager.h"

@interface RDDTransactionsViewController ()
@property (nonatomic, strong) RDDReddAPIManager *reddApi;
@end

@implementation RDDTransactionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureReddAPI];
}

- (void)configureReddAPI
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.reddApi = [[RDDReddAPIManager alloc] initWithGetKey:[defaults stringForKey:kDefaultsReddAPIGETKey]
                                                     postKey:[defaults stringForKey:kDefaultsReddAPIPOSTKey]];
}

@end
