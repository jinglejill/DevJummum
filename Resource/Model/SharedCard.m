//
//  SharedCard.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 12/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedCard.h"

@implementation SharedCard


@synthesize cardList;

+(SharedCard *)sharedCard {
    static dispatch_once_t pred;
    static SharedCard *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedCard alloc] init];
        shared.cardList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
