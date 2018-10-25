//
//  SaveOrderTaking.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveOrderTaking : NSObject
@property (nonatomic) NSInteger saveOrderTakingID;
@property (nonatomic) NSInteger branchID;
@property (nonatomic) NSInteger customerTableID;
@property (nonatomic) NSInteger menuID;
@property (nonatomic) float quantity;
@property (nonatomic) float specialPrice;
@property (nonatomic) float price;
@property (nonatomic) NSInteger takeAway;
@property (nonatomic) float takeAwayPrice;
@property (retain, nonatomic) NSString * noteIDListInText;
@property (nonatomic) float notePrice;
@property (nonatomic) float discountValue;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger saveReceiptID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

- (NSDictionary *)dictionary;
-(SaveOrderTaking *)initWithBranchID:(NSInteger)branchID customerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID quantity:(float)quantity specialPrice:(float)specialPrice price:(float)price takeAway:(NSInteger)takeAway takeAwayPrice:(float)takeAwayPrice noteIDListInText:(NSString *)noteIDListInText notePrice:(float)notePrice discountValue:(float)discountValue orderNo:(NSInteger)orderNo status:(NSInteger)status saveReceiptID:(NSInteger)saveReceiptID;
+(NSInteger)getNextID;
+(void)addObject:(SaveOrderTaking *)saveOrderTaking;
+(void)removeObject:(SaveOrderTaking *)saveOrderTaking;
+(void)addList:(NSMutableArray *)saveOrderTakingList;
+(void)removeList:(NSMutableArray *)saveOrderTakingList;
+(SaveOrderTaking *)getSaveOrderTaking:(NSInteger)saveOrderTakingID;
-(BOOL)editSaveOrderTaking:(SaveOrderTaking *)editingSaveOrderTaking;
+(SaveOrderTaking *)copyFrom:(SaveOrderTaking *)fromSaveOrderTaking to:(SaveOrderTaking *)toSaveOrderTaking;
+(NSMutableArray *)createSaveOrderTakingList:(NSMutableArray *)orderTakingList;



@end
