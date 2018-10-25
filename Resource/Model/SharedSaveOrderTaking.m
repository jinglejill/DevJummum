//
//  SharedSaveOrderTaking.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedSaveOrderTaking.h"

@implementation SharedSaveOrderTaking
@synthesize saveOrderTakingList;

+(SharedSaveOrderTaking *)sharedSaveOrderTaking {
    static dispatch_once_t pred;
    static SharedSaveOrderTaking *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedSaveOrderTaking alloc] init];
        shared.saveOrderTakingList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
