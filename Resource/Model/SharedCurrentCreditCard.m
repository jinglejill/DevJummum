//
//  SharedCurrentCreditCard.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 5/8/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedCurrentCreditCard.h"

@implementation SharedCurrentCreditCard
@synthesize creditCard;

+(SharedCurrentCreditCard *)sharedCurrentCreditCard {
    static dispatch_once_t pred;
    static SharedCurrentCreditCard *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedCurrentCreditCard alloc] init];
        shared.creditCard = nil;
    });
    return shared;
}
@end
