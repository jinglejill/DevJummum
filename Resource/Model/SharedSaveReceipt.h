//
//  SharedSaveReceipt.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedSaveReceipt : NSObject
@property (retain, nonatomic) NSMutableArray *saveReceiptList;

+ (SharedSaveReceipt *)sharedSaveReceipt;

@end
