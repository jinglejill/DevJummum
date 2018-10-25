//
//  Branch.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Branch.h"
#import "SharedBranch.h"
#import "Utility.h"



@implementation Branch

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self valueForKey:@"branchID"]?[self valueForKey:@"branchID"]:[NSNull null],@"branchID",
            [self valueForKey:@"dbName"]?[self valueForKey:@"dbName"]:[NSNull null],@"dbName",
            [self valueForKey:@"mainBranchID"]?[self valueForKey:@"mainBranchID"]:[NSNull null],@"mainBranchID",
            [self valueForKey:@"name"]?[self valueForKey:@"name"]:[NSNull null],@"name",
            [self valueForKey:@"phoneNo"]?[self valueForKey:@"phoneNo"]:[NSNull null],@"phoneNo",
            [self valueForKey:@"status"]?[self valueForKey:@"status"]:[NSNull null],@"status",
            [self valueForKey:@"takeAwayFee"]?[self valueForKey:@"takeAwayFee"]:[NSNull null],@"takeAwayFee",
            [self valueForKey:@"serviceChargePercent"]?[self valueForKey:@"serviceChargePercent"]:[NSNull null],@"serviceChargePercent",
            [self valueForKey:@"percentVat"]?[self valueForKey:@"percentVat"]:[NSNull null],@"percentVat",
            [self valueForKey:@"priceIncludeVat"]?[self valueForKey:@"priceIncludeVat"]:[NSNull null],@"priceIncludeVat",
            [self valueForKey:@"ledStatus"]?[self valueForKey:@"ledStatus"]:[NSNull null],@"ledStatus",
            [self valueForKey:@"openingTimeFromMidNight"]?[self valueForKey:@"openingTimeFromMidNight"]:[NSNull null],@"openingTimeFromMidNight",
            [self valueForKey:@"openingMinute"]?[self valueForKey:@"openingMinute"]:[NSNull null],@"openingMinute",
            [self valueForKey:@"customerApp"]?[self valueForKey:@"customerApp"]:[NSNull null],@"customerApp",
            [self valueForKey:@"imageUrl"]?[self valueForKey:@"imageUrl"]:[NSNull null],@"imageUrl",
            [self valueForKey:@"remark"]?[self valueForKey:@"remark"]:[NSNull null],@"remark",
            [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
            [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
            nil];
}

-(Branch *)initWithDbName:(NSString *)dbName mainBranchID:(NSInteger)mainBranchID name:(NSString *)name phoneNo:(NSString *)phoneNo status:(NSInteger)status takeAwayFee:(NSInteger)takeAwayFee serviceChargePercent:(float)serviceChargePercent percentVat:(float)percentVat priceIncludeVat:(NSInteger)priceIncludeVat ledStatus:(NSInteger)ledStatus openingTimeFromMidNight:(NSInteger)openingTimeFromMidNight openingMinute:(NSInteger)openingMinute customerApp:(NSInteger)customerApp imageUrl:(NSString *)imageUrl remark:(NSString *)remark
{
    self = [super init];
    if(self)
    {
        self.branchID = [Branch getNextID];
        self.dbName = dbName;
        self.mainBranchID = mainBranchID;
        self.name = name;
        self.phoneNo = phoneNo;
        self.status = status;
        self.takeAwayFee = takeAwayFee;
        self.serviceChargePercent = serviceChargePercent;
        self.percentVat = percentVat;
        self.priceIncludeVat = priceIncludeVat;
        self.ledStatus = ledStatus;
        self.openingTimeFromMidNight = openingTimeFromMidNight;
        self.openingMinute = openingMinute;
        self.customerApp = customerApp;
        self.imageUrl = imageUrl;
        self.remark = remark;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"branchID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    
    
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

+(void)addObject:(Branch *)branch
{
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    [dataList addObject:branch];
}

+(void)removeObject:(Branch *)branch
{
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    [dataList removeObject:branch];
}

+(void)addList:(NSMutableArray *)branchList
{
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    [dataList addObjectsFromArray:branchList];
}

+(void)removeList:(NSMutableArray *)branchList
{
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    [dataList removeObjectsInArray:branchList];
}

+(Branch *)getBranch:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld",branchID];
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
        ((Branch *)copy).branchID = self.branchID;
        [copy setDbName:self.dbName];
        ((Branch *)copy).mainBranchID = self.mainBranchID;
        [copy setName:self.name];
        [copy setPhoneNo:self.phoneNo];
        ((Branch *)copy).status = self.status;
        ((Branch *)copy).takeAwayFee = self.takeAwayFee;
        ((Branch *)copy).serviceChargePercent = self.serviceChargePercent;
        ((Branch *)copy).percentVat = self.percentVat;
        ((Branch *)copy).priceIncludeVat = self.priceIncludeVat;
        ((Branch *)copy).ledStatus = self.ledStatus;
        ((Branch *)copy).openingTimeFromMidNight = self.openingTimeFromMidNight;
        ((Branch *)copy).openingMinute = self.openingMinute;
        ((Branch *)copy).customerApp = self.customerApp;
        [copy setImageUrl:self.imageUrl];
        [copy setRemark:self.remark];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editBranch:(Branch *)editingBranch
{
    if(self.branchID == editingBranch.branchID
       && [self.dbName isEqualToString:editingBranch.dbName]
       && self.mainBranchID == editingBranch.mainBranchID
       && [self.name isEqualToString:editingBranch.name]
       && [self.phoneNo isEqualToString:editingBranch.phoneNo]
       && self.status == editingBranch.status
       && self.takeAwayFee == editingBranch.takeAwayFee
       && self.serviceChargePercent == editingBranch.serviceChargePercent
       && self.percentVat == editingBranch.percentVat
       && self.priceIncludeVat == editingBranch.priceIncludeVat
       && self.ledStatus == editingBranch.ledStatus
       && self.openingTimeFromMidNight == editingBranch.openingTimeFromMidNight
       && self.openingMinute == editingBranch.openingMinute
       && self.customerApp == editingBranch.customerApp
       && [self.imageUrl isEqualToString:editingBranch.imageUrl]
       && [self.remark isEqualToString:editingBranch.remark]
       )
    {
        return NO;
    }
    return YES;
}

+(Branch *)copyFrom:(Branch *)fromBranch to:(Branch *)toBranch
{
    toBranch.branchID = fromBranch.branchID;
    toBranch.dbName = fromBranch.dbName;
    toBranch.mainBranchID = fromBranch.mainBranchID;
    toBranch.name = fromBranch.name;
    toBranch.phoneNo = fromBranch.phoneNo;
    toBranch.status = fromBranch.status;
    toBranch.takeAwayFee = fromBranch.takeAwayFee;
    toBranch.serviceChargePercent = fromBranch.serviceChargePercent;
    toBranch.percentVat = fromBranch.percentVat;
    toBranch.priceIncludeVat = fromBranch.priceIncludeVat;
    toBranch.ledStatus = fromBranch.ledStatus;
    toBranch.openingTimeFromMidNight = fromBranch.openingTimeFromMidNight;
    toBranch.openingMinute = fromBranch.openingMinute;
    toBranch.customerApp = fromBranch.customerApp;
    toBranch.imageUrl = fromBranch.imageUrl;
    toBranch.remark = fromBranch.remark;
    toBranch.modifiedUser = [Utility modifiedUser];
    toBranch.modifiedDate = [Utility currentDateTime];
    
    return toBranch;
}

+(NSMutableArray *)getBranchList
{
    return [SharedBranch sharedBranch].branchList;
}

+(NSMutableArray *)sortList:(NSMutableArray *)branchList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [branchList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];    
}

@end
