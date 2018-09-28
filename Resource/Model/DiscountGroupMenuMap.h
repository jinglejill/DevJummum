//
//  DiscountGroupMenuMap.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 21/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountGroupMenuMap : NSObject
@property (nonatomic) NSInteger discountGroupMenuMapID;
@property (nonatomic) NSInteger discountGroupMenuID;
@property (nonatomic) NSInteger menuID;
@property (nonatomic) float quantity;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

- (NSDictionary *)dictionary;
-(DiscountGroupMenuMap *)initWithDiscountGroupMenuID:(NSInteger)discountGroupMenuID menuID:(NSInteger)menuID quantity:(float)quantity;
+(NSInteger)getNextID;
+(void)addObject:(DiscountGroupMenuMap *)discountGroupMenuMap;
+(void)removeObject:(DiscountGroupMenuMap *)discountGroupMenuMap;
+(void)addList:(NSMutableArray *)discountGroupMenuMapList;
+(void)removeList:(NSMutableArray *)discountGroupMenuMapList;
+(DiscountGroupMenuMap *)getDiscountGroupMenuMap:(NSInteger)discountGroupMenuMapID;
-(BOOL)editDiscountGroupMenuMap:(DiscountGroupMenuMap *)editingDiscountGroupMenuMap;
+(DiscountGroupMenuMap *)copyFrom:(DiscountGroupMenuMap *)fromDiscountGroupMenuMap to:(DiscountGroupMenuMap *)toDiscountGroupMenuMap;


@end
