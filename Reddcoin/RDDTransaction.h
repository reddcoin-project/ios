//
//  RDDTransaction.h
//  Reddcoin
//
//  Created by Adam McDonald on 9/24/14.
//  Copyright (c) 2014 Reddcoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDDTransaction : NSObject
- (id)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, assign) BOOL confirmed;
@property (nonatomic, strong) NSString *dateString;
//@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *type;
@end
