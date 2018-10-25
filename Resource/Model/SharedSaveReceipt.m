//
//  SharedSaveReceipt.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedSaveReceipt.h"

@implementation SharedSaveReceipt
@synthesize saveReceiptList;

+(SharedSaveReceipt *)sharedSaveReceipt {
    static dispatch_once_t pred;
    static SharedSaveReceipt *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedSaveReceipt alloc] init];
        shared.saveReceiptList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
