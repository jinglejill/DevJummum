//
//  Zone.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 17/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "Zone.h"
#import "SharedZone.h"
#import "Utility.h"


@implementation Zone

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"zoneID"]?[self valueForKey:@"zoneID"]:[NSNull null],@"zoneID",
        [self valueForKey:@"name"]?[self valueForKey:@"name"]:[NSNull null],@"name",
        [self valueForKey:@"orderNo"]?[self valueForKey:@"orderNo"]:[NSNull null],@"orderNo",
        [self valueForKey:@"status"]?[self valueForKey:@"status"]:[NSNull null],@"status",
        [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
        [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
        nil];
}

-(Zone *)initWithName:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.zoneID = [Zone getNextID];
        self.name = name;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"zoneID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedZone sharedZone].zoneList;


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

+(void)addObject:(Zone *)zone
{
    NSMutableArray *dataList = [SharedZone sharedZone].zoneList;
    [dataList addObject:zone];
}

+(void)removeObject:(Zone *)zone
{
    NSMutableArray *dataList = [SharedZone sharedZone].zoneList;
    [dataList removeObject:zone];
}

+(void)addList:(NSMutableArray *)zoneList
{
    NSMutableArray *dataList = [SharedZone sharedZone].zoneList;
    [dataList addObjectsFromArray:zoneList];
}

+(void)removeList:(NSMutableArray *)zoneList
{
    NSMutableArray *dataList = [SharedZone sharedZone].zoneList;
    [dataList removeObjectsInArray:zoneList];
}

+(Zone *)getZone:(NSInteger)zoneID
{
    NSMutableArray *dataList = [SharedZone sharedZone].zoneList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_zoneID = %ld",zoneID];
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
        ((Zone *)copy).zoneID = self.zoneID;
        [copy setName:self.name];
        ((Zone *)copy).orderNo = self.orderNo;
        ((Zone *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editZone:(Zone *)editingZone
{
    if(self.zoneID == editingZone.zoneID
    && [self.name isEqualToString:editingZone.name]
    && self.orderNo == editingZone.orderNo
    && self.status == editingZone.status
    )
    {
        return NO;
    }
    return YES;
}

+(Zone *)copyFrom:(Zone *)fromZone to:(Zone *)toZone
{
    toZone.zoneID = fromZone.zoneID;
    toZone.name = fromZone.name;
    toZone.orderNo = fromZone.orderNo;
    toZone.status = fromZone.status;
    toZone.modifiedUser = [Utility modifiedUser];
    toZone.modifiedDate = [Utility currentDateTime];
    
    return toZone;
}

@end
