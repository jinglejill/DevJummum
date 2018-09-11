//
//  SharedLuckyDrawTicket.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 8/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedLuckyDrawTicket.h"

@implementation SharedLuckyDrawTicket
@synthesize luckyDrawTicketList;

+(SharedLuckyDrawTicket *)sharedLuckyDrawTicket {
    static dispatch_once_t pred;
    static SharedLuckyDrawTicket *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedLuckyDrawTicket alloc] init];
        shared.luckyDrawTicketList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
