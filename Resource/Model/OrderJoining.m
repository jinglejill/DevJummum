//
//  OrderJoining.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "OrderJoining.h"
#import "SharedOrderJoining.h"
#import "Utility.h"


@implementation OrderJoining

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"orderJoiningID"]?[self valueForKey:@"orderJoiningID"]:[NSNull null],@"orderJoiningID",
        [self valueForKey:@"receiptID"]?[self valueForKey:@"receiptID"]:[NSNull null],@"receiptID",
        [self valueForKey:@"memberID"]?[self valueForKey:@"memberID"]:[NSNull null],@"memberID",
        [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
        [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
        nil];
}

-(OrderJoining *)initWithReceiptID:(NSInteger)receiptID memberID:(NSInteger)memberID
{
    self = [super init];
    if(self)
    {
        self.orderJoiningID = [OrderJoining getNextID];
        self.receiptID = receiptID;
        self.memberID = memberID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"orderJoiningID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedOrderJoining sharedOrderJoining].orderJoiningList;


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

+(void)addObject:(OrderJoining *)orderJoining
{
    NSMutableArray *dataList = [SharedOrderJoining sharedOrderJoining].orderJoiningList;
    [dataList addObject:orderJoining];
}

+(void)removeObject:(OrderJoining *)orderJoining
{
    NSMutableArray *dataList = [SharedOrderJoining sharedOrderJoining].orderJoiningList;
    [dataList removeObject:orderJoining];
}

+(void)addList:(NSMutableArray *)orderJoiningList
{
    NSMutableArray *dataList = [SharedOrderJoining sharedOrderJoining].orderJoiningList;
    [dataList addObjectsFromArray:orderJoiningList];
}

+(void)removeList:(NSMutableArray *)orderJoiningList
{
    NSMutableArray *dataList = [SharedOrderJoining sharedOrderJoining].orderJoiningList;
    [dataList removeObjectsInArray:orderJoiningList];
}

+(OrderJoining *)getOrderJoining:(NSInteger)orderJoiningID
{
    NSMutableArray *dataList = [SharedOrderJoining sharedOrderJoining].orderJoiningList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderJoiningID = %ld",orderJoiningID];
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
        ((OrderJoining *)copy).orderJoiningID = self.orderJoiningID;
        ((OrderJoining *)copy).receiptID = self.receiptID;
        ((OrderJoining *)copy).memberID = self.memberID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editOrderJoining:(OrderJoining *)editingOrderJoining
{
    if(self.orderJoiningID == editingOrderJoining.orderJoiningID
    && self.receiptID == editingOrderJoining.receiptID
    && self.memberID == editingOrderJoining.memberID
    )
    {
        return NO;
    }
    return YES;
}

+(OrderJoining *)copyFrom:(OrderJoining *)fromOrderJoining to:(OrderJoining *)toOrderJoining
{
    toOrderJoining.orderJoiningID = fromOrderJoining.orderJoiningID;
    toOrderJoining.receiptID = fromOrderJoining.receiptID;
    toOrderJoining.memberID = fromOrderJoining.memberID;
    toOrderJoining.modifiedUser = [Utility modifiedUser];
    toOrderJoining.modifiedDate = [Utility currentDateTime];
    
    return toOrderJoining;
}

@end
