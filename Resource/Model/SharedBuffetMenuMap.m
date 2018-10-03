//
//  SharedBuffetMenuMap.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 1/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedBuffetMenuMap.h"

@implementation SharedBuffetMenuMap
@synthesize buffetMenuMapList;
    
+(SharedBuffetMenuMap *)sharedBuffetMenuMap {
    static dispatch_once_t pred;
    static SharedBuffetMenuMap *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedBuffetMenuMap alloc] init];
        shared.buffetMenuMapList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
