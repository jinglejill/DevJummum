//
//  SharedDiscountProgram.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 15/11/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedDiscountProgram.h"

@implementation SharedDiscountProgram
@synthesize discountProgramList;

+(SharedDiscountProgram *)sharedDiscountProgram {
    static dispatch_once_t pred;
    static SharedDiscountProgram *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedDiscountProgram alloc] init];
        shared.discountProgramList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
