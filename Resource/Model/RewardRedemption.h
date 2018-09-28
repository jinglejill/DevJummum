//
//  RewardRedemption.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 24/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardRedemption : NSObject
@property (nonatomic) NSInteger rewardRedemptionID;
@property (nonatomic) NSInteger mainBranchID;
@property (retain, nonatomic) NSDate * startDate;
@property (retain, nonatomic) NSDate * endDate;
@property (retain, nonatomic) NSString * header;
@property (retain, nonatomic) NSString * subTitle;
@property (retain, nonatomic) NSString * imageUrl;
@property (nonatomic) NSInteger point;
@property (retain, nonatomic) NSString * prefixPromoCode;
@property (retain, nonatomic) NSString * suffixPromoCode;
@property (nonatomic) NSInteger rewardLimit;
@property (nonatomic) NSInteger withInPeriod;
@property (retain, nonatomic) NSString * detail;
@property (retain, nonatomic) NSString * termsConditions;
@property (retain, nonatomic) NSDate * usingStartDate;
@property (retain, nonatomic) NSDate * usingEndDate;
@property (nonatomic) NSInteger discountType;
@property (nonatomic) float discountAmount;
@property (nonatomic) float shopDiscount;
@property (nonatomic) float jummumDiscount;
@property (nonatomic) NSInteger sharedDiscountType;
@property (nonatomic) float sharedDiscountAmountMax;
@property (nonatomic) NSInteger minimumSpending;
@property (nonatomic) NSInteger maxDiscountAmountPerDay;
@property (nonatomic) NSInteger allowDiscountForAllMenuType;
@property (nonatomic) NSInteger discountGroupMenuID;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger rewardRank;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;


@property (retain, nonatomic) NSDate * sortDate;
@property (nonatomic) float frequency;
@property (nonatomic) float sales;
@property (retain, nonatomic) NSString * voucherCode;
@property (retain, nonatomic) NSDate * redeemDate;


-(RewardRedemption *)initWithMainBranchID:(NSInteger)mainBranchID startDate:(NSDate *)startDate endDate:(NSDate *)endDate header:(NSString *)header subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl point:(NSInteger)point prefixPromoCode:(NSString *)prefixPromoCode suffixPromoCode:(NSString *)suffixPromoCode rewardLimit:(NSInteger)rewardLimit withInPeriod:(NSInteger)withInPeriod detail:(NSString *)detail termsConditions:(NSString *)termsConditions usingStartDate:(NSDate *)usingStartDate usingEndDate:(NSDate *)usingEndDate discountType:(NSInteger)discountType discountAmount:(float)discountAmount shopDiscount:(float)shopDiscount jummumDiscount:(float)jummumDiscount sharedDiscountType:(NSInteger)sharedDiscountType sharedDiscountAmountMax:(float)sharedDiscountAmountMax minimumSpending:(NSInteger)minimumSpending maxDiscountAmountPerDay:(NSInteger)maxDiscountAmountPerDay allowDiscountForAllMenuType:(NSInteger)allowDiscountForAllMenuType discountGroupMenuID:(NSInteger)discountGroupMenuID type:(NSInteger)type rewardRank:(NSInteger)rewardRank orderNo:(NSInteger)orderNo status:(NSInteger)status;


+(NSInteger)getNextID;
+(void)addObject:(RewardRedemption *)rewardRedemption;
+(void)removeObject:(RewardRedemption *)rewardRedemption;
+(void)addList:(NSMutableArray *)rewardRedemptionList;
+(void)removeList:(NSMutableArray *)rewardRedemptionList;
+(RewardRedemption *)getRewardRedemption:(NSInteger)rewardRedemptionID;
-(BOOL)editRewardRedemption:(RewardRedemption *)editingRewardRedemption;
+(RewardRedemption *)copyFrom:(RewardRedemption *)fromRewardRedemption to:(RewardRedemption *)toRewardRedemption;
+(NSMutableArray *)sort:(NSMutableArray *)rewardRedemptionList;
+(NSMutableArray *)getRewardRedemptionList;
+(void)removeAllObjects;
@end
