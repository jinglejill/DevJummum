//
//  SharedDiscountGroupMenuMap.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 21/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedDiscountGroupMenuMap : NSObject

@property (retain, nonatomic) NSMutableArray *discountGroupMenuMapList;

+ (SharedDiscountGroupMenuMap *)sharedDiscountGroupMenuMap;

@end
