//
//  SharedVoucherCode.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 17/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedVoucherCode.h"

@implementation SharedVoucherCode
@synthesize voucherCode;

+(SharedVoucherCode *)sharedVoucherCode {
    static dispatch_once_t pred;
    static SharedVoucherCode *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedVoucherCode alloc] init];
        shared.voucherCode = [[VoucherCode alloc]init];
    });
    return shared;
}

@end
