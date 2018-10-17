//
//  VoucherCode.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 17/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoucherCode : NSObject
@property (retain, nonatomic) NSString * code;

+(VoucherCode *)getCurrentVoucherCode;
+(void)setCurrentVoucherCode:(VoucherCode *)voucherCode;
+(void)removeCurrentVoucherCode;
@end
