//
//  SaveOrderNote.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveOrderNote : NSObject
@property (nonatomic) NSInteger saveOrderNoteID;
@property (nonatomic) NSInteger saveOrderTakingID;
@property (nonatomic) NSInteger noteID;
@property (nonatomic) float quantity;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

- (NSDictionary *)dictionary;
-(SaveOrderNote *)initWithSaveOrderTakingID:(NSInteger)saveOrderTakingID noteID:(NSInteger)noteID quantity:(float)quantity;
+(NSInteger)getNextID;
+(void)addObject:(SaveOrderNote *)saveOrderNote;
+(void)removeObject:(SaveOrderNote *)saveOrderNote;
+(void)addList:(NSMutableArray *)saveOrderNoteList;
+(void)removeList:(NSMutableArray *)saveOrderNoteList;
+(SaveOrderNote *)getSaveOrderNote:(NSInteger)saveOrderNoteID;
-(BOOL)editSaveOrderNote:(SaveOrderNote *)editingSaveOrderNote;
+(SaveOrderNote *)copyFrom:(SaveOrderNote *)fromSaveOrderNote to:(SaveOrderNote *)toSaveOrderNote;
+(NSMutableArray *)createSaveOrderNoteList:(NSMutableArray *)orderNoteList;
+(NSMutableArray *)getOrderNoteListWithSaveOrderTakingID:(NSInteger)saveOrderTakingID;
@end
