//
//  Promotion.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Promotion.h"
#import "SharedPromotion.h"
#import "Utility.h"

#import "SharedPromotion.h"
#import "Utility.h"


@implementation Promotion

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self valueForKey:@"promotionID"]?[self valueForKey:@"promotionID"]:[NSNull null],@"promotionID",
            [self valueForKey:@"mainBranchID"]?[self valueForKey:@"mainBranchID"]:[NSNull null],@"mainBranchID",
            [Utility dateToString:[self valueForKey:@"startDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"startDate",
            [Utility dateToString:[self valueForKey:@"endDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"endDate",
            [Utility dateToString:[self valueForKey:@"usingStartDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"usingStartDate",
            [Utility dateToString:[self valueForKey:@"usingEndDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"usingEndDate",
            [self valueForKey:@"header"]?[self valueForKey:@"header"]:[NSNull null],@"header",
            [self valueForKey:@"subTitle"]?[self valueForKey:@"subTitle"]:[NSNull null],@"subTitle",
            [self valueForKey:@"imageUrl"]?[self valueForKey:@"imageUrl"]:[NSNull null],@"imageUrl",
            [self valueForKey:@"discountType"]?[self valueForKey:@"discountType"]:[NSNull null],@"discountType",
            [self valueForKey:@"discountAmount"]?[self valueForKey:@"discountAmount"]:[NSNull null],@"discountAmount",
            [self valueForKey:@"shopDiscount"]?[self valueForKey:@"shopDiscount"]:[NSNull null],@"shopDiscount",
            [self valueForKey:@"jummumDiscount"]?[self valueForKey:@"jummumDiscount"]:[NSNull null],@"jummumDiscount",
            [self valueForKey:@"sharedDiscountType"]?[self valueForKey:@"sharedDiscountType"]:[NSNull null],@"sharedDiscountType",
            [self valueForKey:@"sharedDiscountAmountMax"]?[self valueForKey:@"sharedDiscountAmountMax"]:[NSNull null],@"sharedDiscountAmountMax",
            [self valueForKey:@"minimumSpending"]?[self valueForKey:@"minimumSpending"]:[NSNull null],@"minimumSpending",
            [self valueForKey:@"maxDiscountAmountPerDay"]?[self valueForKey:@"maxDiscountAmountPerDay"]:[NSNull null],@"maxDiscountAmountPerDay",
            [self valueForKey:@"allowEveryone"]?[self valueForKey:@"allowEveryone"]:[NSNull null],@"allowEveryone",
            [self valueForKey:@"allowDiscountForAllMenuType"]?[self valueForKey:@"allowDiscountForAllMenuType"]:[NSNull null],@"allowDiscountForAllMenuType",
            [self valueForKey:@"discountGroupMenuID"]?[self valueForKey:@"discountGroupMenuID"]:[NSNull null],@"discountGroupMenuID",
            [self valueForKey:@"discountMenuMaxQuantity"]?[self valueForKey:@"discountMenuMaxQuantity"]:[NSNull null],@"discountMenuMaxQuantity",
            [self valueForKey:@"noOfLimitUse"]?[self valueForKey:@"noOfLimitUse"]:[NSNull null],@"noOfLimitUse",
            [self valueForKey:@"noOfLimitUsePerUser"]?[self valueForKey:@"noOfLimitUsePerUser"]:[NSNull null],@"noOfLimitUsePerUser",
            [self valueForKey:@"noOfLimitUsePerUserPerDay"]?[self valueForKey:@"noOfLimitUsePerUserPerDay"]:[NSNull null],@"noOfLimitUsePerUserPerDay",
            [self valueForKey:@"voucherCode"]?[self valueForKey:@"voucherCode"]:[NSNull null],@"voucherCode",
            [self valueForKey:@"termsConditions"]?[self valueForKey:@"termsConditions"]:[NSNull null],@"termsConditions",
            [self valueForKey:@"type"]?[self valueForKey:@"type"]:[NSNull null],@"type",
            [self valueForKey:@"orderNo"]?[self valueForKey:@"orderNo"]:[NSNull null],@"orderNo",
            [self valueForKey:@"status"]?[self valueForKey:@"status"]:[NSNull null],@"status",
            [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
            [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
            nil];
}

-(Promotion *)initWithMainBranchID:(NSInteger)mainBranchID startDate:(NSDate *)startDate endDate:(NSDate *)endDate usingStartDate:(NSDate *)usingStartDate usingEndDate:(NSDate *)usingEndDate header:(NSString *)header subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl discountType:(NSInteger)discountType discountAmount:(float)discountAmount shopDiscount:(float)shopDiscount jummumDiscount:(float)jummumDiscount sharedDiscountType:(NSInteger)sharedDiscountType sharedDiscountAmountMax:(float)sharedDiscountAmountMax minimumSpending:(NSInteger)minimumSpending maxDiscountAmountPerDay:(NSInteger)maxDiscountAmountPerDay allowEveryone:(NSInteger)allowEveryone allowDiscountForAllMenuType:(NSInteger)allowDiscountForAllMenuType discountGroupMenuID:(NSInteger)discountGroupMenuID discountMenuMaxQuantity:(NSInteger)discountMenuMaxQuantity noOfLimitUse:(NSInteger)noOfLimitUse noOfLimitUsePerUser:(NSInteger)noOfLimitUsePerUser noOfLimitUsePerUserPerDay:(NSInteger)noOfLimitUsePerUserPerDay voucherCode:(NSString *)voucherCode termsConditions:(NSString *)termsConditions type:(NSInteger)type orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.promotionID = [Promotion getNextID];
        self.mainBranchID = mainBranchID;
        self.startDate = startDate;
        self.endDate = endDate;
        self.usingStartDate = usingStartDate;
        self.usingEndDate = usingEndDate;
        self.header = header;
        self.subTitle = subTitle;
        self.imageUrl = imageUrl;
        self.discountType = discountType;
        self.discountAmount = discountAmount;
        self.shopDiscount = shopDiscount;
        self.jummumDiscount = jummumDiscount;
        self.sharedDiscountType = sharedDiscountType;
        self.sharedDiscountAmountMax = sharedDiscountAmountMax;
        self.minimumSpending = minimumSpending;
        self.maxDiscountAmountPerDay = maxDiscountAmountPerDay;
        self.allowEveryone = allowEveryone;
        self.allowDiscountForAllMenuType = allowDiscountForAllMenuType;
        self.discountGroupMenuID = discountGroupMenuID;
        self.discountMenuMaxQuantity = discountMenuMaxQuantity;
        self.noOfLimitUse = noOfLimitUse;
        self.noOfLimitUsePerUser = noOfLimitUsePerUser;
        self.noOfLimitUsePerUserPerDay = noOfLimitUsePerUserPerDay;
        self.voucherCode = voucherCode;
        self.termsConditions = termsConditions;
        self.type = type;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"promotionID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    
    
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

+(void)addObject:(Promotion *)promotion
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    [dataList addObject:promotion];
}

+(void)removeObject:(Promotion *)promotion
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    [dataList removeObject:promotion];
}

+(void)addList:(NSMutableArray *)promotionList
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    [dataList addObjectsFromArray:promotionList];
}

+(void)removeList:(NSMutableArray *)promotionList
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    [dataList removeObjectsInArray:promotionList];
}

+(Promotion *)getPromotion:(NSInteger)promotionID
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_promotionID = %ld",promotionID];
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
        ((Promotion *)copy).promotionID = self.promotionID;
        ((Promotion *)copy).mainBranchID = self.mainBranchID;
        [copy setStartDate:self.startDate];
        [copy setEndDate:self.endDate];
        [copy setUsingStartDate:self.usingStartDate];
        [copy setUsingEndDate:self.usingEndDate];
        [copy setHeader:self.header];
        [copy setSubTitle:self.subTitle];
        [copy setImageUrl:self.imageUrl];
        ((Promotion *)copy).discountType = self.discountType;
        ((Promotion *)copy).discountAmount = self.discountAmount;
        ((Promotion *)copy).shopDiscount = self.shopDiscount;
        ((Promotion *)copy).jummumDiscount = self.jummumDiscount;
        ((Promotion *)copy).sharedDiscountType = self.sharedDiscountType;
        ((Promotion *)copy).sharedDiscountAmountMax = self.sharedDiscountAmountMax;
        ((Promotion *)copy).minimumSpending = self.minimumSpending;
        ((Promotion *)copy).maxDiscountAmountPerDay = self.maxDiscountAmountPerDay;
        ((Promotion *)copy).allowEveryone = self.allowEveryone;
        ((Promotion *)copy).allowDiscountForAllMenuType = self.allowDiscountForAllMenuType;
        ((Promotion *)copy).discountGroupMenuID = self.discountGroupMenuID;
        ((Promotion *)copy).discountMenuMaxQuantity = self.discountMenuMaxQuantity;
        ((Promotion *)copy).noOfLimitUse = self.noOfLimitUse;
        ((Promotion *)copy).noOfLimitUsePerUser = self.noOfLimitUsePerUser;
        ((Promotion *)copy).noOfLimitUsePerUserPerDay = self.noOfLimitUsePerUserPerDay;
        [copy setVoucherCode:self.voucherCode];
        [copy setTermsConditions:self.termsConditions];
        ((Promotion *)copy).type = self.type;
        ((Promotion *)copy).orderNo = self.orderNo;
        ((Promotion *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editPromotion:(Promotion *)editingPromotion
{
    if(self.promotionID == editingPromotion.promotionID
       && self.mainBranchID == editingPromotion.mainBranchID
       && [self.startDate isEqual:editingPromotion.startDate]
       && [self.endDate isEqual:editingPromotion.endDate]
       && [self.usingStartDate isEqual:editingPromotion.usingStartDate]
       && [self.usingEndDate isEqual:editingPromotion.usingEndDate]
       && [self.header isEqualToString:editingPromotion.header]
       && [self.subTitle isEqualToString:editingPromotion.subTitle]
       && [self.imageUrl isEqualToString:editingPromotion.imageUrl]
       && self.discountType == editingPromotion.discountType
       && self.discountAmount == editingPromotion.discountAmount
       && self.shopDiscount == editingPromotion.shopDiscount
       && self.jummumDiscount == editingPromotion.jummumDiscount
       && self.sharedDiscountType == editingPromotion.sharedDiscountType
       && self.sharedDiscountAmountMax == editingPromotion.sharedDiscountAmountMax
       && self.minimumSpending == editingPromotion.minimumSpending
       && self.maxDiscountAmountPerDay == editingPromotion.maxDiscountAmountPerDay
       && self.allowEveryone == editingPromotion.allowEveryone
       && self.allowDiscountForAllMenuType == editingPromotion.allowDiscountForAllMenuType
       && self.discountGroupMenuID == editingPromotion.discountGroupMenuID
       && self.discountMenuMaxQuantity == editingPromotion.discountMenuMaxQuantity
       && self.noOfLimitUse == editingPromotion.noOfLimitUse
       && self.noOfLimitUsePerUser == editingPromotion.noOfLimitUsePerUser
       && self.noOfLimitUsePerUserPerDay == editingPromotion.noOfLimitUsePerUserPerDay
       && [self.voucherCode isEqualToString:editingPromotion.voucherCode]
       && [self.termsConditions isEqualToString:editingPromotion.termsConditions]
       && self.type == editingPromotion.type
       && self.orderNo == editingPromotion.orderNo
       && self.status == editingPromotion.status
       )
    {
        return NO;
    }
    return YES;
}

+(Promotion *)copyFrom:(Promotion *)fromPromotion to:(Promotion *)toPromotion
{
    toPromotion.promotionID = fromPromotion.promotionID;
    toPromotion.mainBranchID = fromPromotion.mainBranchID;
    toPromotion.startDate = fromPromotion.startDate;
    toPromotion.endDate = fromPromotion.endDate;
    toPromotion.usingStartDate = fromPromotion.usingStartDate;
    toPromotion.usingEndDate = fromPromotion.usingEndDate;
    toPromotion.header = fromPromotion.header;
    toPromotion.subTitle = fromPromotion.subTitle;
    toPromotion.imageUrl = fromPromotion.imageUrl;
    toPromotion.discountType = fromPromotion.discountType;
    toPromotion.discountAmount = fromPromotion.discountAmount;
    toPromotion.shopDiscount = fromPromotion.shopDiscount;
    toPromotion.jummumDiscount = fromPromotion.jummumDiscount;
    toPromotion.sharedDiscountType = fromPromotion.sharedDiscountType;
    toPromotion.sharedDiscountAmountMax = fromPromotion.sharedDiscountAmountMax;
    toPromotion.minimumSpending = fromPromotion.minimumSpending;
    toPromotion.maxDiscountAmountPerDay = fromPromotion.maxDiscountAmountPerDay;
    toPromotion.allowEveryone = fromPromotion.allowEveryone;
    toPromotion.allowDiscountForAllMenuType = fromPromotion.allowDiscountForAllMenuType;
    toPromotion.discountGroupMenuID = fromPromotion.discountGroupMenuID;
    toPromotion.discountMenuMaxQuantity = fromPromotion.discountMenuMaxQuantity;
    toPromotion.noOfLimitUse = fromPromotion.noOfLimitUse;
    toPromotion.noOfLimitUsePerUser = fromPromotion.noOfLimitUsePerUser;
    toPromotion.noOfLimitUsePerUserPerDay = fromPromotion.noOfLimitUsePerUserPerDay;
    toPromotion.voucherCode = fromPromotion.voucherCode;
    toPromotion.termsConditions = fromPromotion.termsConditions;
    toPromotion.type = fromPromotion.type;
    toPromotion.orderNo = fromPromotion.orderNo;
    toPromotion.status = fromPromotion.status;
    toPromotion.modifiedUser = [Utility modifiedUser];
    toPromotion.modifiedDate = [Utility currentDateTime];
    
    return toPromotion;
}


+(NSMutableArray *)getPromotionList
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_type" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_frequency" ascending:NO];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_sales" ascending:NO];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(void)removeAllObjects
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    [dataList removeAllObjects];
}
@end
