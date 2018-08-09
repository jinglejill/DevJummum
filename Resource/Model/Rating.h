//
//  Rating.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 8/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rating : NSObject
@property (nonatomic) NSInteger ratingID;
@property (nonatomic) NSInteger receiptID;
@property (nonatomic) NSInteger score;
@property (retain, nonatomic) NSString * comment;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(Rating *)initWithReceiptID:(NSInteger)receiptID score:(NSInteger)score comment:(NSString *)comment;
+(NSInteger)getNextID;
+(void)addObject:(Rating *)rating;
+(void)removeObject:(Rating *)rating;
+(void)addList:(NSMutableArray *)ratingList;
+(void)removeList:(NSMutableArray *)ratingList;
+(Rating *)getRating:(NSInteger)ratingID;
-(BOOL)editRating:(Rating *)editingRating;
+(Rating *)copyFrom:(Rating *)fromRating to:(Rating *)toRating;
+(Rating *)getRatingWithReceiptID:(NSInteger)receiptID;
+(NSString *)getTextWithScore:(NSInteger)score;

@end
