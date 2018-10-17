//
//  VoucherCode.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 17/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "VoucherCode.h"
#import "SharedVoucherCode.h"


@implementation VoucherCode
+(VoucherCode *)getCurrentVoucherCode
{
    return [SharedVoucherCode sharedVoucherCode].voucherCode;
}

+(void)setCurrentVoucherCode:(VoucherCode *)voucherCode
{
    [SharedVoucherCode sharedVoucherCode].voucherCode = voucherCode;
}

+(void)removeCurrentVoucherCode
{
    [SharedVoucherCode sharedVoucherCode].voucherCode = nil;
}
@end
