//
//  SharedRecommendShop.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedRecommendShop.h"

@implementation SharedRecommendShop
@synthesize recommendShopList;

+(SharedRecommendShop *)sharedRecommendShop {
    static dispatch_once_t pred;
    static SharedRecommendShop *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedRecommendShop alloc] init];
        shared.recommendShopList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
