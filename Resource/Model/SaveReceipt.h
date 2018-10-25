//
//  SaveReceipt.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveReceipt : NSObject
@property (nonatomic) NSInteger saveReceiptID;
@property (nonatomic) NSInteger branchID;
@property (nonatomic) NSInteger customerTableID;
@property (nonatomic) NSInteger memberID;
@property (retain, nonatomic) NSString * remark;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger buffetReceiptID;
@property (retain, nonatomic) NSString * voucherCode;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

- (NSDictionary *)dictionary;
-(SaveReceipt *)initWithBranchID:(NSInteger)branchID customerTableID:(NSInteger)customerTableID memberID:(NSInteger)memberID remark:(NSString *)remark status:(NSInteger)status buffetReceiptID:(NSInteger)buffetReceiptID voucherCode:(NSString *)voucherCode;
+(NSInteger)getNextID;
+(void)addObject:(SaveReceipt *)saveReceipt;
+(void)removeObject:(SaveReceipt *)saveReceipt;
+(void)addList:(NSMutableArray *)saveReceiptList;
+(void)removeList:(NSMutableArray *)saveReceiptList;
+(SaveReceipt *)getSaveReceipt:(NSInteger)saveReceiptID;
-(BOOL)editSaveReceipt:(SaveReceipt *)editingSaveReceipt;
+(SaveReceipt *)copyFrom:(SaveReceipt *)fromSaveReceipt to:(SaveReceipt *)toSaveReceipt;

+(SaveReceipt *)getCurrentSaveReceipt;
+(void)setCurrentSaveReceipt:(SaveReceipt *)saveReceipt;
+(void)removeCurrentSaveReceipt;

@end
