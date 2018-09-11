//
//  LuckyDrawTicket.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 8/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuckyDrawTicket : NSObject
@property (nonatomic) NSInteger luckyDrawTicketID;
@property (nonatomic) NSInteger receiptID;
@property (nonatomic) NSInteger memberID;
@property (nonatomic) NSInteger rewardRedemptionID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

-(LuckyDrawTicket *)initWithReceiptID:(NSInteger)receiptID memberID:(NSInteger)memberID rewardRedemptionID:(NSInteger)rewardRedemptionID;
+(NSInteger)getNextID;
+(void)addObject:(LuckyDrawTicket *)luckyDrawTicket;
+(void)removeObject:(LuckyDrawTicket *)luckyDrawTicket;
+(void)addList:(NSMutableArray *)luckyDrawTicketList;
+(void)removeList:(NSMutableArray *)luckyDrawTicketList;
+(LuckyDrawTicket *)getLuckyDrawTicket:(NSInteger)luckyDrawTicketID;
-(BOOL)editLuckyDrawTicket:(LuckyDrawTicket *)editingLuckyDrawTicket;
+(LuckyDrawTicket *)copyFrom:(LuckyDrawTicket *)fromLuckyDrawTicket to:(LuckyDrawTicket *)toLuckyDrawTicket;




@end
