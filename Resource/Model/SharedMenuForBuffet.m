//
//  SharedMenuForBuffet.m
//  DemoJummum
//
//  Created by Thidaporn Kijkamjai on 25/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedMenuForBuffet.h"

@implementation SharedMenuForBuffet
@synthesize menuForBuffet;
    
+(SharedMenuForBuffet *)sharedMenuForBuffet {
    static dispatch_once_t pred;
    static SharedMenuForBuffet *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMenuForBuffet alloc] init];
        shared.menuForBuffet = [[MenuForBuffet alloc]init];
    });
    return shared;
}
    

@end
