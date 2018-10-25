//
//  SharedCurrentSaveReceipt.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 25/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaveReceipt.h"


@interface SharedCurrentSaveReceipt : NSObject
@property (retain, nonatomic) SaveReceipt *saveReceipt;

+ (SharedCurrentSaveReceipt *)sharedCurrentSaveReceipt;
@end
