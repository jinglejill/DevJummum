//
//  SharedRating.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 8/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedRating.h"

@implementation SharedRating
@synthesize ratingList;

+(SharedRating *)sharedRating {
    static dispatch_once_t pred;
    static SharedRating *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedRating alloc] init];
        shared.ratingList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
