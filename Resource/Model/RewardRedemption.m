//
//  RewardRedemption.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 24/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardRedemption.h"
#import "SharedRewardRedemption.h"
#import "Utility.h"


@implementation RewardRedemption

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self valueForKey:@"rewardRedemptionID"]?[self valueForKey:@"rewardRedemptionID"]:[NSNull null],@"rewardRedemptionID",
            [self valueForKey:@"mainBranchID"]?[self valueForKey:@"mainBranchID"]:[NSNull null],@"mainBranchID",
            [Utility dateToString:[self valueForKey:@"startDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"startDate",
            [Utility dateToString:[self valueForKey:@"endDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"endDate",
            [self valueForKey:@"header"]?[self valueForKey:@"header"]:[NSNull null],@"header",
            [self valueForKey:@"subTitle"]?[self valueForKey:@"subTitle"]:[NSNull null],@"subTitle",
            [self valueForKey:@"imageUrl"]?[self valueForKey:@"imageUrl"]:[NSNull null],@"imageUrl",
            [self valueForKey:@"point"]?[self valueForKey:@"point"]:[NSNull null],@"point",
            [self valueForKey:@"prefixPromoCode"]?[self valueForKey:@"prefixPromoCode"]:[NSNull null],@"prefixPromoCode",
            [self valueForKey:@"suffixPromoCode"]?[self valueForKey:@"suffixPromoCode"]:[NSNull null],@"suffixPromoCode",
            [self valueForKey:@"rewardLimit"]?[self valueForKey:@"rewardLimit"]:[NSNull null],@"rewardLimit",
            [self valueForKey:@"withInPeriod"]?[self valueForKey:@"withInPeriod"]:[NSNull null],@"withInPeriod",
            [self valueForKey:@"detail"]?[self valueForKey:@"detail"]:[NSNull null],@"detail",
            [self valueForKey:@"termsConditions"]?[self valueForKey:@"termsConditions"]:[NSNull null],@"termsConditions",
            [Utility dateToString:[self valueForKey:@"usingStartDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"usingStartDate",
            [Utility dateToString:[self valueForKey:@"usingEndDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"usingEndDate",
            [self valueForKey:@"discountType"]?[self valueForKey:@"discountType"]:[NSNull null],@"discountType",
            [self valueForKey:@"discountAmount"]?[self valueForKey:@"discountAmount"]:[NSNull null],@"discountAmount",
            [self valueForKey:@"shopDiscount"]?[self valueForKey:@"shopDiscount"]:[NSNull null],@"shopDiscount",
            [self valueForKey:@"jummumDiscount"]?[self valueForKey:@"jummumDiscount"]:[NSNull null],@"jummumDiscount",
            [self valueForKey:@"sharedDiscountType"]?[self valueForKey:@"sharedDiscountType"]:[NSNull null],@"sharedDiscountType",
            [self valueForKey:@"sharedDiscountAmountMax"]?[self valueForKey:@"sharedDiscountAmountMax"]:[NSNull null],@"sharedDiscountAmountMax",
            [self valueForKey:@"minimumSpending"]?[self valueForKey:@"minimumSpending"]:[NSNull null],@"minimumSpending",
            [self valueForKey:@"maxDiscountAmountPerDay"]?[self valueForKey:@"maxDiscountAmountPerDay"]:[NSNull null],@"maxDiscountAmountPerDay",
            [self valueForKey:@"allowDiscountForAllMenuType"]?[self valueForKey:@"allowDiscountForAllMenuType"]:[NSNull null],@"allowDiscountForAllMenuType",
            [self valueForKey:@"discountGroupMenuID"]?[self valueForKey:@"discountGroupMenuID"]:[NSNull null],@"discountGroupMenuID",
            [self valueForKey:@"type"]?[self valueForKey:@"type"]:[NSNull null],@"type",
            [self valueForKey:@"rewardRank"]?[self valueForKey:@"rewardRank"]:[NSNull null],@"rewardRank",
            [self valueForKey:@"orderNo"]?[self valueForKey:@"orderNo"]:[NSNull null],@"orderNo",
            [self valueForKey:@"status"]?[self valueForKey:@"status"]:[NSNull null],@"status",
            [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
            [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
            nil];
}

-(RewardRedemption *)initWithMainBranchID:(NSInteger)mainBranchID startDate:(NSDate *)startDate endDate:(NSDate *)endDate header:(NSString *)header subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl point:(NSInteger)point prefixPromoCode:(NSString *)prefixPromoCode suffixPromoCode:(NSString *)suffixPromoCode rewardLimit:(NSInteger)rewardLimit withInPeriod:(NSInteger)withInPeriod detail:(NSString *)detail termsConditions:(NSString *)termsConditions usingStartDate:(NSDate *)usingStartDate usingEndDate:(NSDate *)usingEndDate discountType:(NSInteger)discountType discountAmount:(float)discountAmount shopDiscount:(float)shopDiscount jummumDiscount:(float)jummumDiscount sharedDiscountType:(NSInteger)sharedDiscountType sharedDiscountAmountMax:(float)sharedDiscountAmountMax minimumSpending:(NSInteger)minimumSpending maxDiscountAmountPerDay:(NSInteger)maxDiscountAmountPerDay allowDiscountForAllMenuType:(NSInteger)allowDiscountForAllMenuType discountGroupMenuID:(NSInteger)discountGroupMenuID type:(NSInteger)type rewardRank:(NSInteger)rewardRank orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.rewardRedemptionID = [RewardRedemption getNextID];
        self.mainBranchID = mainBranchID;
        self.startDate = startDate;
        self.endDate = endDate;
        self.header = header;
        self.subTitle = subTitle;
        self.imageUrl = imageUrl;
        self.point = point;
        self.prefixPromoCode = prefixPromoCode;
        self.suffixPromoCode = suffixPromoCode;
        self.rewardLimit = rewardLimit;
        self.withInPeriod = withInPeriod;
        self.detail = detail;
        self.termsConditions = termsConditions;
        self.usingStartDate = usingStartDate;
        self.usingEndDate = usingEndDate;
        self.discountType = discountType;
        self.discountAmount = discountAmount;
        self.shopDiscount = shopDiscount;
        self.jummumDiscount = jummumDiscount;
        self.sharedDiscountType = sharedDiscountType;
        self.sharedDiscountAmountMax = sharedDiscountAmountMax;
        self.minimumSpending = minimumSpending;
        self.maxDiscountAmountPerDay = maxDiscountAmountPerDay;
        self.allowDiscountForAllMenuType = allowDiscountForAllMenuType;
        self.discountGroupMenuID = discountGroupMenuID;
        self.type = type;
        self.rewardRank = rewardRank;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"rewardRedemptionID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    
    
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

+(void)addObject:(RewardRedemption *)rewardRedemption
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    [dataList addObject:rewardRedemption];
}

+(void)removeObject:(RewardRedemption *)rewardRedemption
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    [dataList removeObject:rewardRedemption];
}

+(void)addList:(NSMutableArray *)rewardRedemptionList
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    [dataList addObjectsFromArray:rewardRedemptionList];
}

+(void)removeList:(NSMutableArray *)rewardRedemptionList
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    [dataList removeObjectsInArray:rewardRedemptionList];
}

+(RewardRedemption *)getRewardRedemption:(NSInteger)rewardRedemptionID
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_rewardRedemptionID = %ld",rewardRedemptionID];
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
        ((RewardRedemption *)copy).rewardRedemptionID = self.rewardRedemptionID;
        ((RewardRedemption *)copy).mainBranchID = self.mainBranchID;
        [copy setStartDate:self.startDate];
        [copy setEndDate:self.endDate];
        [copy setHeader:self.header];
        [copy setSubTitle:self.subTitle];
        [copy setImageUrl:self.imageUrl];
        ((RewardRedemption *)copy).point = self.point;
        [copy setPrefixPromoCode:self.prefixPromoCode];
        [copy setSuffixPromoCode:self.suffixPromoCode];
        ((RewardRedemption *)copy).rewardLimit = self.rewardLimit;
        ((RewardRedemption *)copy).withInPeriod = self.withInPeriod;
        [copy setDetail:self.detail];
        [copy setTermsConditions:self.termsConditions];
        [copy setUsingStartDate:self.usingStartDate];
        [copy setUsingEndDate:self.usingEndDate];
        ((RewardRedemption *)copy).discountType = self.discountType;
        ((RewardRedemption *)copy).discountAmount = self.discountAmount;
        ((RewardRedemption *)copy).shopDiscount = self.shopDiscount;
        ((RewardRedemption *)copy).jummumDiscount = self.jummumDiscount;
        ((RewardRedemption *)copy).sharedDiscountType = self.sharedDiscountType;
        ((RewardRedemption *)copy).sharedDiscountAmountMax = self.sharedDiscountAmountMax;
        ((RewardRedemption *)copy).minimumSpending = self.minimumSpending;
        ((RewardRedemption *)copy).maxDiscountAmountPerDay = self.maxDiscountAmountPerDay;
        ((RewardRedemption *)copy).allowDiscountForAllMenuType = self.allowDiscountForAllMenuType;
        ((RewardRedemption *)copy).discountGroupMenuID = self.discountGroupMenuID;
        ((RewardRedemption *)copy).type = self.type;
        ((RewardRedemption *)copy).rewardRank = self.rewardRank;
        ((RewardRedemption *)copy).orderNo = self.orderNo;
        ((RewardRedemption *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editRewardRedemption:(RewardRedemption *)editingRewardRedemption
{
    if(self.rewardRedemptionID == editingRewardRedemption.rewardRedemptionID
       && self.mainBranchID == editingRewardRedemption.mainBranchID
       && [self.startDate isEqual:editingRewardRedemption.startDate]
       && [self.endDate isEqual:editingRewardRedemption.endDate]
       && [self.header isEqualToString:editingRewardRedemption.header]
       && [self.subTitle isEqualToString:editingRewardRedemption.subTitle]
       && [self.imageUrl isEqualToString:editingRewardRedemption.imageUrl]
       && self.point == editingRewardRedemption.point
       && [self.prefixPromoCode isEqualToString:editingRewardRedemption.prefixPromoCode]
       && [self.suffixPromoCode isEqualToString:editingRewardRedemption.suffixPromoCode]
       && self.rewardLimit == editingRewardRedemption.rewardLimit
       && self.withInPeriod == editingRewardRedemption.withInPeriod
       && [self.detail isEqualToString:editingRewardRedemption.detail]
       && [self.termsConditions isEqualToString:editingRewardRedemption.termsConditions]
       && [self.usingStartDate isEqual:editingRewardRedemption.usingStartDate]
       && [self.usingEndDate isEqual:editingRewardRedemption.usingEndDate]
       && self.discountType == editingRewardRedemption.discountType
       && self.discountAmount == editingRewardRedemption.discountAmount
       && self.shopDiscount == editingRewardRedemption.shopDiscount
       && self.jummumDiscount == editingRewardRedemption.jummumDiscount
       && self.sharedDiscountType == editingRewardRedemption.sharedDiscountType
       && self.sharedDiscountAmountMax == editingRewardRedemption.sharedDiscountAmountMax
       && self.minimumSpending == editingRewardRedemption.minimumSpending
       && self.maxDiscountAmountPerDay == editingRewardRedemption.maxDiscountAmountPerDay
       && self.allowDiscountForAllMenuType == editingRewardRedemption.allowDiscountForAllMenuType
       && self.discountGroupMenuID == editingRewardRedemption.discountGroupMenuID
       && self.type == editingRewardRedemption.type
       && self.rewardRank == editingRewardRedemption.rewardRank
       && self.orderNo == editingRewardRedemption.orderNo
       && self.status == editingRewardRedemption.status
       )
    {
        return NO;
    }
    return YES;
}

+(RewardRedemption *)copyFrom:(RewardRedemption *)fromRewardRedemption to:(RewardRedemption *)toRewardRedemption
{
    toRewardRedemption.rewardRedemptionID = fromRewardRedemption.rewardRedemptionID;
    toRewardRedemption.mainBranchID = fromRewardRedemption.mainBranchID;
    toRewardRedemption.startDate = fromRewardRedemption.startDate;
    toRewardRedemption.endDate = fromRewardRedemption.endDate;
    toRewardRedemption.header = fromRewardRedemption.header;
    toRewardRedemption.subTitle = fromRewardRedemption.subTitle;
    toRewardRedemption.imageUrl = fromRewardRedemption.imageUrl;
    toRewardRedemption.point = fromRewardRedemption.point;
    toRewardRedemption.prefixPromoCode = fromRewardRedemption.prefixPromoCode;
    toRewardRedemption.suffixPromoCode = fromRewardRedemption.suffixPromoCode;
    toRewardRedemption.rewardLimit = fromRewardRedemption.rewardLimit;
    toRewardRedemption.withInPeriod = fromRewardRedemption.withInPeriod;
    toRewardRedemption.detail = fromRewardRedemption.detail;
    toRewardRedemption.termsConditions = fromRewardRedemption.termsConditions;
    toRewardRedemption.usingStartDate = fromRewardRedemption.usingStartDate;
    toRewardRedemption.usingEndDate = fromRewardRedemption.usingEndDate;
    toRewardRedemption.discountType = fromRewardRedemption.discountType;
    toRewardRedemption.discountAmount = fromRewardRedemption.discountAmount;
    toRewardRedemption.shopDiscount = fromRewardRedemption.shopDiscount;
    toRewardRedemption.jummumDiscount = fromRewardRedemption.jummumDiscount;
    toRewardRedemption.sharedDiscountType = fromRewardRedemption.sharedDiscountType;
    toRewardRedemption.sharedDiscountAmountMax = fromRewardRedemption.sharedDiscountAmountMax;
    toRewardRedemption.minimumSpending = fromRewardRedemption.minimumSpending;
    toRewardRedemption.maxDiscountAmountPerDay = fromRewardRedemption.maxDiscountAmountPerDay;
    toRewardRedemption.allowDiscountForAllMenuType = fromRewardRedemption.allowDiscountForAllMenuType;
    toRewardRedemption.discountGroupMenuID = fromRewardRedemption.discountGroupMenuID;
    toRewardRedemption.type = fromRewardRedemption.type;
    toRewardRedemption.rewardRank = fromRewardRedemption.rewardRank;
    toRewardRedemption.orderNo = fromRewardRedemption.orderNo;
    toRewardRedemption.status = fromRewardRedemption.status;
    toRewardRedemption.modifiedUser = [Utility modifiedUser];
    toRewardRedemption.modifiedDate = [Utility currentDateTime];
    
    return toRewardRedemption;
}



+(NSMutableArray *)sort:(NSMutableArray *)rewardRedemptionList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_sortDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [rewardRedemptionList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getRewardRedemptionList
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_frequency" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_sales" ascending:NO];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];

    return [sortArray mutableCopy];
}

+(void)removeAllObjects
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    [dataList removeAllObjects];
}

+(NSInteger)getIndexOfObject:(RewardRedemption *)rewardRedemption rewardRedemptionList:(NSMutableArray *)rewardRedemptionList
{
    for(int i=0; i<[rewardRedemptionList count]; i++)
    {
        RewardRedemption *item = rewardRedemptionList[i];
        if(item == rewardRedemption)
//        if(item.rewardRedemptionID == rewardRedemption.rewardRedemptionID && [rewardRedemption.voucherCode isEqualToString:item.voucherCode])
        {
            return i;
        }
    }
    return -1;
}
@end

