//
//  Comment.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property (nonatomic) NSInteger commentID;
@property (nonatomic) NSInteger userAccountID;
@property (retain, nonatomic) NSString * text;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger receiptID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(Comment *)initWithUserAccountID:(NSInteger)userAccountID text:(NSString *)text type:(NSInteger)type receiptID:(NSInteger)receiptID;
+(NSInteger)getNextID;
+(void)addObject:(Comment *)comment;
+(void)removeObject:(Comment *)comment;
+(void)addList:(NSMutableArray *)commentList;
+(void)removeList:(NSMutableArray *)commentList;
+(Comment *)getComment:(NSInteger)commentID;
-(BOOL)editComment:(Comment *)editingComment;
+(Comment *)copyFrom:(Comment *)fromComment to:(Comment *)toComment;




@end
