//
//  Promotion.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Promotion : NSObject
@property (nonatomic) NSInteger promotionID;
@property (nonatomic) NSInteger mainBranchID;
@property (retain, nonatomic) NSDate * startDate;
@property (retain, nonatomic) NSDate * endDate;
@property (retain, nonatomic) NSDate * usingStartDate;
@property (retain, nonatomic) NSDate * usingEndDate;
@property (retain, nonatomic) NSString * header;
@property (retain, nonatomic) NSString * subTitle;
@property (retain, nonatomic) NSString * imageUrl;
@property (nonatomic) NSInteger discountType;
@property (nonatomic) float discountAmount;
@property (nonatomic) float shopDiscount;
@property (nonatomic) float jummumDiscount;
@property (nonatomic) NSInteger sharedDiscountType;
@property (nonatomic) float sharedDiscountAmountMax;
@property (nonatomic) NSInteger minimumSpending;
@property (nonatomic) NSInteger maxDiscountAmountPerDay;
@property (nonatomic) NSInteger allowEveryone;
@property (nonatomic) NSInteger allowDiscountForAllMenuType;
@property (nonatomic) NSInteger discountGroupMenuID;
@property (nonatomic) NSInteger discountMenuMaxQuantity;
@property (nonatomic) NSInteger noOfLimitUse;
@property (nonatomic) NSInteger noOfLimitUsePerUser;
@property (nonatomic) NSInteger noOfLimitUsePerUserPerDay;
@property (retain, nonatomic) NSString * voucherCode;
@property (retain, nonatomic) NSString * termsConditions;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

@property (retain, nonatomic) NSString * error;
@property (nonatomic) float discountValue;
@property (nonatomic) NSInteger rewardRedemptionID;
@property (nonatomic) NSInteger promoCodeID;
@property (nonatomic) float frequency;
@property (nonatomic) float sales;
@property (nonatomic) BOOL selected;


-(Promotion *)initWithMainBranchID:(NSInteger)mainBranchID startDate:(NSDate *)startDate endDate:(NSDate *)endDate usingStartDate:(NSDate *)usingStartDate usingEndDate:(NSDate *)usingEndDate header:(NSString *)header subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl discountType:(NSInteger)discountType discountAmount:(float)discountAmount shopDiscount:(float)shopDiscount jummumDiscount:(float)jummumDiscount sharedDiscountType:(NSInteger)sharedDiscountType sharedDiscountAmountMax:(float)sharedDiscountAmountMax minimumSpending:(NSInteger)minimumSpending maxDiscountAmountPerDay:(NSInteger)maxDiscountAmountPerDay allowEveryone:(NSInteger)allowEveryone allowDiscountForAllMenuType:(NSInteger)allowDiscountForAllMenuType discountGroupMenuID:(NSInteger)discountGroupMenuID discountMenuMaxQuantity:(NSInteger)discountMenuMaxQuantity noOfLimitUse:(NSInteger)noOfLimitUse noOfLimitUsePerUser:(NSInteger)noOfLimitUsePerUser noOfLimitUsePerUserPerDay:(NSInteger)noOfLimitUsePerUserPerDay voucherCode:(NSString *)voucherCode termsConditions:(NSString *)termsConditions type:(NSInteger)type orderNo:(NSInteger)orderNo status:(NSInteger)status;

+(NSInteger)getNextID;
+(void)addObject:(Promotion *)promotion;
+(void)removeObject:(Promotion *)promotion;
+(void)addList:(NSMutableArray *)promotionList;
+(void)removeList:(NSMutableArray *)promotionList;
+(Promotion *)getPromotion:(NSInteger)promotionID;
-(BOOL)editPromotion:(Promotion *)editingPromotion;
+(Promotion *)copyFrom:(Promotion *)fromPromotion to:(Promotion *)toPromotion;
+(NSMutableArray *)getPromotionList;
+(void)removeAllObjects;

@end
