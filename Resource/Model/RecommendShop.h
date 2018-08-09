//
//  RecommendShop.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendShop : NSObject
@property (nonatomic) NSInteger recommendShopID;
@property (nonatomic) NSInteger userAccountID;
@property (retain, nonatomic) NSString * text;
@property (nonatomic) NSInteger type;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(RecommendShop *)initWithUserAccountID:(NSInteger)userAccountID text:(NSString *)text type:(NSInteger)type;
+(NSInteger)getNextID;
+(void)addObject:(RecommendShop *)recommendShop;
+(void)removeObject:(RecommendShop *)recommendShop;
+(void)addList:(NSMutableArray *)recommendShopList;
+(void)removeList:(NSMutableArray *)recommendShopList;
+(RecommendShop *)getRecommendShop:(NSInteger)recommendShopID;
-(BOOL)editRecommendShop:(RecommendShop *)editingRecommendShop;
+(RecommendShop *)copyFrom:(RecommendShop *)fromRecommendShop to:(RecommendShop *)toRecommendShop;


@end
