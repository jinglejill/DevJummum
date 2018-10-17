//
//  SharedVoucherCode.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 17/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoucherCode.h"

@interface SharedVoucherCode : NSObject
@property (retain, nonatomic) VoucherCode *voucherCode;

+ (SharedVoucherCode *)sharedVoucherCode;
@end
