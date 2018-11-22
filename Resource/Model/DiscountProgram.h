//
//  DiscountProgram.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 15/11/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountProgram : NSObject
@property (nonatomic) NSInteger discountProgramID;
@property (retain, nonatomic) NSDate * startDate;
@property (retain, nonatomic) NSDate * endDate;
@property (retain, nonatomic) NSString * title;
@property (retain, nonatomic) NSString * detail;
@property (nonatomic) NSInteger discountType;
@property (nonatomic) float amount;
@property (nonatomic) NSInteger minimumSpend;
@property (nonatomic) NSInteger noOfLimitUsePerUserPerDay;
@property (nonatomic) NSInteger discountGroupMenuID;
@property (nonatomic) NSInteger discountStepID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

@property (nonatomic) float discountValue;


- (NSDictionary *)dictionary;
-(DiscountProgram *)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate title:(NSString *)title detail:(NSString *)detail discountType:(NSInteger)discountType amount:(float)amount minimumSpend:(NSInteger)minimumSpend noOfLimitUsePerUserPerDay:(NSInteger)noOfLimitUsePerUserPerDay discountGroupMenuID:(NSInteger)discountGroupMenuID discountStepID:(NSInteger)discountStepID;
+(NSInteger)getNextID;
+(void)addObject:(DiscountProgram *)discountProgram;
+(void)removeObject:(DiscountProgram *)discountProgram;
+(void)addList:(NSMutableArray *)discountProgramList;
+(void)removeList:(NSMutableArray *)discountProgramList;
+(DiscountProgram *)getDiscountProgram:(NSInteger)discountProgramID;
-(BOOL)editDiscountProgram:(DiscountProgram *)editingDiscountProgram;
+(DiscountProgram *)copyFrom:(DiscountProgram *)fromDiscountProgram to:(DiscountProgram *)toDiscountProgram;


@end
