//
//  SharedOrderJoining.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedOrderJoining.h"

@implementation SharedOrderJoining
@synthesize orderJoiningList;

+(SharedOrderJoining *)sharedOrderJoining {
    static dispatch_once_t pred;
    static SharedOrderJoining *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedOrderJoining alloc] init];
        shared.orderJoiningList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
