//
//  NoteType.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteType : NSObject
@property (nonatomic) NSInteger noteTypeID;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * nameEn;
@property (nonatomic) NSInteger allowQuantity;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

@property (nonatomic) NSInteger branchID;

@property (nonatomic) NSInteger type;
-(NoteType *)initWithName:(NSString *)name nameEn:(NSString *)nameEn allowQuantity:(NSInteger)allowQuantity orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(NoteType *)noteType;
+(void)removeObject:(NoteType *)noteType;
+(void)addList:(NSMutableArray *)noteTypeList;
+(void)removeList:(NSMutableArray *)noteTypeList;
+(NoteType *)getNoteType:(NSInteger)noteTypeID branchID:(NSInteger)branchID;
-(BOOL)editNoteType:(NoteType *)editingNoteType;
+(NoteType *)copyFrom:(NoteType *)fromNoteType to:(NoteType *)toNoteType;
+(void)setSharedData:(NSMutableArray *)dataList;
+(NSMutableArray *)getNoteTypeList;
+(NSMutableArray *)sort:(NSMutableArray *)noteTypeList;
@end
