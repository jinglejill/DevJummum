//
//  Branch.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Branch : NSObject
@property (nonatomic) NSInteger branchID;
@property (retain, nonatomic) NSString * dbName;
@property (nonatomic) NSInteger mainBranchID;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * phoneNo;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger takeAwayFee;
@property (nonatomic) float serviceChargePercent;
@property (nonatomic) float percentVat;
@property (nonatomic) NSInteger priceIncludeVat;
@property (nonatomic) NSInteger ledStatus;
@property (nonatomic) NSInteger openingTimeFromMidNight;
@property (nonatomic) NSInteger openingMinute;
@property (nonatomic) NSInteger customerApp;
@property (retain, nonatomic) NSString * imageUrl;
@property (retain, nonatomic) NSString * remark;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;


@property (nonatomic) float luckyDrawSpend;
@property (retain, nonatomic) NSString * wordAdd;
@property (retain, nonatomic) NSString * wordNo;

-(Branch *)initWithDbName:(NSString *)dbName mainBranchID:(NSInteger)mainBranchID name:(NSString *)name phoneNo:(NSString *)phoneNo status:(NSInteger)status takeAwayFee:(NSInteger)takeAwayFee serviceChargePercent:(float)serviceChargePercent percentVat:(float)percentVat priceIncludeVat:(NSInteger)priceIncludeVat ledStatus:(NSInteger)ledStatus openingTimeFromMidNight:(NSInteger)openingTimeFromMidNight openingMinute:(NSInteger)openingMinute customerApp:(NSInteger)customerApp imageUrl:(NSString *)imageUrl remark:(NSString *)remark;
+(NSInteger)getNextID;
+(void)addObject:(Branch *)branch;
+(void)removeObject:(Branch *)branch;
+(void)addList:(NSMutableArray *)branchList;
+(void)removeList:(NSMutableArray *)branchList;
+(Branch *)getBranch:(NSInteger)branchID;
-(BOOL)editBranch:(Branch *)editingBranch;
+(Branch *)copyFrom:(Branch *)fromBranch to:(Branch *)toBranch;
+(NSMutableArray *)getBranchList;
+(NSString *)getAddress:(Branch *)branch;
+(NSMutableArray *)sortList:(NSMutableArray *)branchList;

@end
