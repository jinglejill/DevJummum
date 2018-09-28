//
//  SharedDiscountGroupMenuMap.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 21/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedDiscountGroupMenuMap.h"

@implementation SharedDiscountGroupMenuMap
@synthesize discountGroupMenuMapList;

+(SharedDiscountGroupMenuMap *)sharedDiscountGroupMenuMap {
    static dispatch_once_t pred;
    static SharedDiscountGroupMenuMap *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedDiscountGroupMenuMap alloc] init];
        shared.discountGroupMenuMapList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
