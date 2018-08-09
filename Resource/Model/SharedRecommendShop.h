//
//  SharedRecommendShop.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedRecommendShop : NSObject
@property (retain, nonatomic) NSMutableArray *recommendShopList;

+ (SharedRecommendShop *)sharedRecommendShop;
@end
