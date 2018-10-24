//
//  OrderJoining.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderJoining : NSObject
@property (nonatomic) NSInteger orderJoiningID;
@property (nonatomic) NSInteger receiptID;
@property (nonatomic) NSInteger memberID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

- (NSDictionary *)dictionary;
-(OrderJoining *)initWithReceiptID:(NSInteger)receiptID memberID:(NSInteger)memberID;
+(NSInteger)getNextID;
+(void)addObject:(OrderJoining *)orderJoining;
+(void)removeObject:(OrderJoining *)orderJoining;
+(void)addList:(NSMutableArray *)orderJoiningList;
+(void)removeList:(NSMutableArray *)orderJoiningList;
+(OrderJoining *)getOrderJoining:(NSInteger)orderJoiningID;
-(BOOL)editOrderJoining:(OrderJoining *)editingOrderJoining;
+(OrderJoining *)copyFrom:(OrderJoining *)fromOrderJoining to:(OrderJoining *)toOrderJoining;




@end
