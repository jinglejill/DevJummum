//
//  MenuNote.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 11/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuNote : NSObject
@property (nonatomic) NSInteger menuNoteID;
@property (nonatomic) NSInteger menuID;
@property (nonatomic) NSInteger noteID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

@property (nonatomic) NSInteger branchID;

-(MenuNote *)initWithMenuID:(NSInteger)menuID noteID:(NSInteger)noteID;
+(NSInteger)getNextID;
+(void)addObject:(MenuNote *)menuNote;
+(void)removeObject:(MenuNote *)menuNote;
+(void)addList:(NSMutableArray *)menuNoteList;
+(void)removeList:(NSMutableArray *)menuNoteList;
+(MenuNote *)getMenuNote:(NSInteger)menuNoteID;
-(BOOL)editMenuNote:(MenuNote *)editingMenuNote;
+(MenuNote *)copyFrom:(MenuNote *)fromMenuNote to:(MenuNote *)toMenuNote;
+(NSMutableArray *)getMenuNoteList;
+(void)setSharedData:(NSMutableArray *)dataList;
+(NSMutableArray *)getNoteListWithMenuID:(NSInteger)menuID branchID:(NSInteger)branchID;
@end
