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

-(Promotion *)initWithMainBranchID:(NSInteger)mainBranchID startDate:(NSDate *)startDate endDate:(NSDate *)endDate usingStartDate:(NSDate *)usingStartDate usingEndDate:(NSDate *)usingEndDate header:(NSString *)header subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl discountType:(NSInteger)discountType discountAmount:(float)discountAmount minimumSpending:(NSInteger)minimumSpending maxDiscountAmountPerDay:(NSInteger)maxDiscountAmountPerDay allowEveryone:(NSInteger)allowEveryone allowDiscountForAllMenuType:(NSInteger)allowDiscountForAllMenuType discountMenuID:(NSInteger)discountMenuID noOfLimitUse:(NSInteger)noOfLimitUse noOfLimitUsePerUser:(NSInteger)noOfLimitUsePerUser noOfLimitUsePerUserPerDay:(NSInteger)noOfLimitUsePerUserPerDay voucherCode:(NSString *)voucherCode termsConditions:(NSString *)termsConditions type:(NSInteger)type orderNo:(NSInteger)orderNo status:(NSInteger)status
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
        self.minimumSpending = minimumSpending;
        self.maxDiscountAmountPerDay = maxDiscountAmountPerDay;
        self.allowEveryone = allowEveryone;
        self.allowDiscountForAllMenuType = allowDiscountForAllMenuType;
        self.discountMenuID = discountMenuID;
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
        ((Promotion *)copy).minimumSpending = self.minimumSpending;
        ((Promotion *)copy).maxDiscountAmountPerDay = self.maxDiscountAmountPerDay;
        ((Promotion *)copy).allowEveryone = self.allowEveryone;
        ((Promotion *)copy).allowDiscountForAllMenuType = self.allowDiscountForAllMenuType;
        ((Promotion *)copy).discountMenuID = self.discountMenuID;
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
       && self.minimumSpending == editingPromotion.minimumSpending
       && self.maxDiscountAmountPerDay == editingPromotion.maxDiscountAmountPerDay
       && self.allowEveryone == editingPromotion.allowEveryone
       && self.allowDiscountForAllMenuType == editingPromotion.allowDiscountForAllMenuType
       && self.discountMenuID == editingPromotion.discountMenuID
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
    toPromotion.minimumSpending = fromPromotion.minimumSpending;
    toPromotion.maxDiscountAmountPerDay = fromPromotion.maxDiscountAmountPerDay;
    toPromotion.allowEveryone = fromPromotion.allowEveryone;
    toPromotion.allowDiscountForAllMenuType = fromPromotion.allowDiscountForAllMenuType;
    toPromotion.discountMenuID = fromPromotion.discountMenuID;
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

+(NSMutableArray *)sortWithdataList:(NSMutableArray *)dataList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_type" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_frequency" ascending:NO];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_sales" ascending:NO];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

@end
