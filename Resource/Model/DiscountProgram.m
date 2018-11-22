//
//  DiscountProgram.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 15/11/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "DiscountProgram.h"
#import "SharedDiscountProgram.h"
#import "Utility.h"


@implementation DiscountProgram

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"discountProgramID"]?[self valueForKey:@"discountProgramID"]:[NSNull null],@"discountProgramID",
        [Utility dateToString:[self valueForKey:@"startDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"startDate",
        [Utility dateToString:[self valueForKey:@"endDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"endDate",
        [self valueForKey:@"title"]?[self valueForKey:@"title"]:[NSNull null],@"title",
        [self valueForKey:@"detail"]?[self valueForKey:@"detail"]:[NSNull null],@"detail",
        [self valueForKey:@"discountType"]?[self valueForKey:@"discountType"]:[NSNull null],@"discountType",
        [self valueForKey:@"amount"]?[self valueForKey:@"amount"]:[NSNull null],@"amount",
        [self valueForKey:@"minimumSpend"]?[self valueForKey:@"minimumSpend"]:[NSNull null],@"minimumSpend",
        [self valueForKey:@"noOfLimitUsePerUserPerDay"]?[self valueForKey:@"noOfLimitUsePerUserPerDay"]:[NSNull null],@"noOfLimitUsePerUserPerDay",
        [self valueForKey:@"discountGroupMenuID"]?[self valueForKey:@"discountGroupMenuID"]:[NSNull null],@"discountGroupMenuID",
        [self valueForKey:@"discountStepID"]?[self valueForKey:@"discountStepID"]:[NSNull null],@"discountStepID",
        [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
        [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
        nil];
}

-(DiscountProgram *)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate title:(NSString *)title detail:(NSString *)detail discountType:(NSInteger)discountType amount:(float)amount minimumSpend:(NSInteger)minimumSpend noOfLimitUsePerUserPerDay:(NSInteger)noOfLimitUsePerUserPerDay discountGroupMenuID:(NSInteger)discountGroupMenuID discountStepID:(NSInteger)discountStepID
{
    self = [super init];
    if(self)
    {
        self.discountProgramID = [DiscountProgram getNextID];
        self.startDate = startDate;
        self.endDate = endDate;
        self.title = title;
        self.detail = detail;
        self.discountType = discountType;
        self.amount = amount;
        self.minimumSpend = minimumSpend;
        self.noOfLimitUsePerUserPerDay = noOfLimitUsePerUserPerDay;
        self.discountGroupMenuID = discountGroupMenuID;
        self.discountStepID = discountStepID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"discountProgramID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedDiscountProgram sharedDiscountProgram].discountProgramList;


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

+(void)addObject:(DiscountProgram *)discountProgram
{
    NSMutableArray *dataList = [SharedDiscountProgram sharedDiscountProgram].discountProgramList;
    [dataList addObject:discountProgram];
}

+(void)removeObject:(DiscountProgram *)discountProgram
{
    NSMutableArray *dataList = [SharedDiscountProgram sharedDiscountProgram].discountProgramList;
    [dataList removeObject:discountProgram];
}

+(void)addList:(NSMutableArray *)discountProgramList
{
    NSMutableArray *dataList = [SharedDiscountProgram sharedDiscountProgram].discountProgramList;
    [dataList addObjectsFromArray:discountProgramList];
}

+(void)removeList:(NSMutableArray *)discountProgramList
{
    NSMutableArray *dataList = [SharedDiscountProgram sharedDiscountProgram].discountProgramList;
    [dataList removeObjectsInArray:discountProgramList];
}

+(DiscountProgram *)getDiscountProgram:(NSInteger)discountProgramID
{
    NSMutableArray *dataList = [SharedDiscountProgram sharedDiscountProgram].discountProgramList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_discountProgramID = %ld",discountProgramID];
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
        ((DiscountProgram *)copy).discountProgramID = self.discountProgramID;
        [copy setStartDate:self.startDate];
        [copy setEndDate:self.endDate];
        [copy setTitle:self.title];
        [copy setDetail:self.detail];
        ((DiscountProgram *)copy).discountType = self.discountType;
        ((DiscountProgram *)copy).amount = self.amount;
        ((DiscountProgram *)copy).minimumSpend = self.minimumSpend;
        ((DiscountProgram *)copy).noOfLimitUsePerUserPerDay = self.noOfLimitUsePerUserPerDay;
        ((DiscountProgram *)copy).discountGroupMenuID = self.discountGroupMenuID;
        ((DiscountProgram *)copy).discountStepID = self.discountStepID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editDiscountProgram:(DiscountProgram *)editingDiscountProgram
{
    if(self.discountProgramID == editingDiscountProgram.discountProgramID
    && [self.startDate isEqual:editingDiscountProgram.startDate]
    && [self.endDate isEqual:editingDiscountProgram.endDate]
    && [self.title isEqualToString:editingDiscountProgram.title]
    && [self.detail isEqualToString:editingDiscountProgram.detail]
    && self.discountType == editingDiscountProgram.discountType
    && self.amount == editingDiscountProgram.amount
    && self.minimumSpend == editingDiscountProgram.minimumSpend
    && self.noOfLimitUsePerUserPerDay == editingDiscountProgram.noOfLimitUsePerUserPerDay
    && self.discountGroupMenuID == editingDiscountProgram.discountGroupMenuID
    && self.discountStepID == editingDiscountProgram.discountStepID
    )
    {
        return NO;
    }
    return YES;
}

+(DiscountProgram *)copyFrom:(DiscountProgram *)fromDiscountProgram to:(DiscountProgram *)toDiscountProgram
{
    toDiscountProgram.discountProgramID = fromDiscountProgram.discountProgramID;
    toDiscountProgram.startDate = fromDiscountProgram.startDate;
    toDiscountProgram.endDate = fromDiscountProgram.endDate;
    toDiscountProgram.title = fromDiscountProgram.title;
    toDiscountProgram.detail = fromDiscountProgram.detail;
    toDiscountProgram.discountType = fromDiscountProgram.discountType;
    toDiscountProgram.amount = fromDiscountProgram.amount;
    toDiscountProgram.minimumSpend = fromDiscountProgram.minimumSpend;
    toDiscountProgram.noOfLimitUsePerUserPerDay = fromDiscountProgram.noOfLimitUsePerUserPerDay;
    toDiscountProgram.discountGroupMenuID = fromDiscountProgram.discountGroupMenuID;
    toDiscountProgram.discountStepID = fromDiscountProgram.discountStepID;
    toDiscountProgram.modifiedUser = [Utility modifiedUser];
    toDiscountProgram.modifiedDate = [Utility currentDateTime];
    
    return toDiscountProgram;
}

@end
