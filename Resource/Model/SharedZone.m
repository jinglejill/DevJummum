//
//  SharedZone.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 17/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedZone.h"

@implementation SharedZone
@synthesize zoneList;

+(SharedZone *)sharedZone {
    static dispatch_once_t pred;
    static SharedZone *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedZone alloc] init];
        shared.zoneList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
