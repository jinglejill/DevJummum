//
//  SharedCurrentSaveReceipt.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 25/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedCurrentSaveReceipt.h"

@implementation SharedCurrentSaveReceipt
@synthesize saveReceipt;

+(SharedCurrentSaveReceipt *)sharedCurrentSaveReceipt {
    static dispatch_once_t pred;
    static SharedCurrentSaveReceipt *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedCurrentSaveReceipt alloc] init];
        shared.saveReceipt = nil;
    });
    return shared;
}
@end
