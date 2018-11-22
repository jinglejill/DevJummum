//
//  SharedDiscountProgram.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 15/11/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedDiscountProgram : NSObject
@property (retain, nonatomic) NSMutableArray *discountProgramList;
+ (SharedDiscountProgram *)sharedDiscountProgram;
@end
