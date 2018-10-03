//
//  BuffetMenuMap.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 1/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "BuffetMenuMap.h"
#import "SharedBuffetMenuMap.h"
#import "Utility.h"


@implementation BuffetMenuMap
    
- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self valueForKey:@"buffetMenuMapID"]?[self valueForKey:@"buffetMenuMapID"]:[NSNull null],@"buffetMenuMapID",
            [self valueForKey:@"buffetMenuID"]?[self valueForKey:@"buffetMenuID"]:[NSNull null],@"buffetMenuID",
            [self valueForKey:@"menuID"]?[self valueForKey:@"menuID"]:[NSNull null],@"menuID",
            [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
            [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
            nil];
}
    
-(BuffetMenuMap *)initWithBuffetMenuID:(NSInteger)buffetMenuID menuID:(NSInteger)menuID
{
    self = [super init];
    if(self)
    {
        self.buffetMenuMapID = [BuffetMenuMap getNextID];
        self.buffetMenuID = buffetMenuID;
        self.menuID = menuID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}
    
+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"buffetMenuMapID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedBuffetMenuMap sharedBuffetMenuMap].buffetMenuMapList;
    
    
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
    
+(void)addObject:(BuffetMenuMap *)buffetMenuMap
{
    NSMutableArray *dataList = [SharedBuffetMenuMap sharedBuffetMenuMap].buffetMenuMapList;
    [dataList addObject:buffetMenuMap];
}
    
+(void)removeObject:(BuffetMenuMap *)buffetMenuMap
{
    NSMutableArray *dataList = [SharedBuffetMenuMap sharedBuffetMenuMap].buffetMenuMapList;
    [dataList removeObject:buffetMenuMap];
}
    
+(void)addList:(NSMutableArray *)buffetMenuMapList
{
    NSMutableArray *dataList = [SharedBuffetMenuMap sharedBuffetMenuMap].buffetMenuMapList;
    [dataList addObjectsFromArray:buffetMenuMapList];
}
    
+(void)removeList:(NSMutableArray *)buffetMenuMapList
{
    NSMutableArray *dataList = [SharedBuffetMenuMap sharedBuffetMenuMap].buffetMenuMapList;
    [dataList removeObjectsInArray:buffetMenuMapList];
}
    
+(BuffetMenuMap *)getBuffetMenuMap:(NSInteger)buffetMenuMapID
{
    NSMutableArray *dataList = [SharedBuffetMenuMap sharedBuffetMenuMap].buffetMenuMapList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_buffetMenuMapID = %ld",buffetMenuMapID];
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
        ((BuffetMenuMap *)copy).buffetMenuMapID = self.buffetMenuMapID;
        ((BuffetMenuMap *)copy).buffetMenuID = self.buffetMenuID;
        ((BuffetMenuMap *)copy).menuID = self.menuID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}
    
-(BOOL)editBuffetMenuMap:(BuffetMenuMap *)editingBuffetMenuMap
{
    if(self.buffetMenuMapID == editingBuffetMenuMap.buffetMenuMapID
       && self.buffetMenuID == editingBuffetMenuMap.buffetMenuID
       && self.menuID == editingBuffetMenuMap.menuID
       )
    {
        return NO;
    }
    return YES;
}
    
+(BuffetMenuMap *)copyFrom:(BuffetMenuMap *)fromBuffetMenuMap to:(BuffetMenuMap *)toBuffetMenuMap
{
    toBuffetMenuMap.buffetMenuMapID = fromBuffetMenuMap.buffetMenuMapID;
    toBuffetMenuMap.buffetMenuID = fromBuffetMenuMap.buffetMenuID;
    toBuffetMenuMap.menuID = fromBuffetMenuMap.menuID;
    toBuffetMenuMap.modifiedUser = [Utility modifiedUser];
    toBuffetMenuMap.modifiedDate = [Utility currentDateTime];
    
    return toBuffetMenuMap;
}
@end
