//
//  DiscountGroupMenuMap.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 21/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "DiscountGroupMenuMap.h"
#import "SharedDiscountGroupMenuMap.h"
#import "Utility.h"


@implementation DiscountGroupMenuMap
- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self valueForKey:@"discountGroupMenuMapID"]?[self valueForKey:@"discountGroupMenuMapID"]:[NSNull null],@"discountGroupMenuMapID",
            [self valueForKey:@"discountGroupMenuID"]?[self valueForKey:@"discountGroupMenuID"]:[NSNull null],@"discountGroupMenuID",
            [self valueForKey:@"menuID"]?[self valueForKey:@"menuID"]:[NSNull null],@"menuID",
            [self valueForKey:@"quantity"]?[self valueForKey:@"quantity"]:[NSNull null],@"quantity",
            [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
            [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
            nil];
}

-(DiscountGroupMenuMap *)initWithDiscountGroupMenuID:(NSInteger)discountGroupMenuID menuID:(NSInteger)menuID quantity:(float)quantity
{
    self = [super init];
    if(self)
    {
        self.discountGroupMenuMapID = [DiscountGroupMenuMap getNextID];
        self.discountGroupMenuID = discountGroupMenuID;
        self.menuID = menuID;
        self.quantity = quantity;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"discountGroupMenuMapID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedDiscountGroupMenuMap sharedDiscountGroupMenuMap].discountGroupMenuMapList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return -1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        if([value integerValue]>0)
        {
            return -1;
        }
        else
        {
            return [value integerValue]-1;
        }
    }
}

+(void)addObject:(DiscountGroupMenuMap *)discountGroupMenuMap
{
    NSMutableArray *dataList = [SharedDiscountGroupMenuMap sharedDiscountGroupMenuMap].discountGroupMenuMapList;
    [dataList addObject:discountGroupMenuMap];
}

+(void)removeObject:(DiscountGroupMenuMap *)discountGroupMenuMap
{
    NSMutableArray *dataList = [SharedDiscountGroupMenuMap sharedDiscountGroupMenuMap].discountGroupMenuMapList;
    [dataList removeObject:discountGroupMenuMap];
}

+(void)addList:(NSMutableArray *)discountGroupMenuMapList
{
    NSMutableArray *dataList = [SharedDiscountGroupMenuMap sharedDiscountGroupMenuMap].discountGroupMenuMapList;
    [dataList addObjectsFromArray:discountGroupMenuMapList];
}

+(void)removeList:(NSMutableArray *)discountGroupMenuMapList
{
    NSMutableArray *dataList = [SharedDiscountGroupMenuMap sharedDiscountGroupMenuMap].discountGroupMenuMapList;
    [dataList removeObjectsInArray:discountGroupMenuMapList];
}

+(DiscountGroupMenuMap *)getDiscountGroupMenuMap:(NSInteger)discountGroupMenuMapID
{
    NSMutableArray *dataList = [SharedDiscountGroupMenuMap sharedDiscountGroupMenuMap].discountGroupMenuMapList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_discountGroupMenuMapID = %ld",discountGroupMenuMapID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((DiscountGroupMenuMap *)copy).discountGroupMenuMapID = self.discountGroupMenuMapID;
        ((DiscountGroupMenuMap *)copy).discountGroupMenuID = self.discountGroupMenuID;
        ((DiscountGroupMenuMap *)copy).menuID = self.menuID;
        ((DiscountGroupMenuMap *)copy).quantity = self.quantity;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editDiscountGroupMenuMap:(DiscountGroupMenuMap *)editingDiscountGroupMenuMap
{
    if(self.discountGroupMenuMapID == editingDiscountGroupMenuMap.discountGroupMenuMapID
       && self.discountGroupMenuID == editingDiscountGroupMenuMap.discountGroupMenuID
       && self.menuID == editingDiscountGroupMenuMap.menuID
       && self.quantity == editingDiscountGroupMenuMap.quantity
       )
    {
        return NO;
    }
    return YES;
}

+(DiscountGroupMenuMap *)copyFrom:(DiscountGroupMenuMap *)fromDiscountGroupMenuMap to:(DiscountGroupMenuMap *)toDiscountGroupMenuMap
{
    toDiscountGroupMenuMap.discountGroupMenuMapID = fromDiscountGroupMenuMap.discountGroupMenuMapID;
    toDiscountGroupMenuMap.discountGroupMenuID = fromDiscountGroupMenuMap.discountGroupMenuID;
    toDiscountGroupMenuMap.menuID = fromDiscountGroupMenuMap.menuID;
    toDiscountGroupMenuMap.quantity = fromDiscountGroupMenuMap.quantity;
    toDiscountGroupMenuMap.modifiedUser = [Utility modifiedUser];
    toDiscountGroupMenuMap.modifiedDate = [Utility currentDateTime];
    
    return toDiscountGroupMenuMap;
}
@end
