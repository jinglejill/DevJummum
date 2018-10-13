//
//  MenuType.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuType : NSObject
@property (nonatomic) NSInteger menuTypeID;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * nameEn;
@property (nonatomic) NSInteger allowDiscount;
@property (retain, nonatomic) NSString * color;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;


@property (nonatomic) NSInteger branchID;



-(MenuType *)initWithName:(NSString *)name nameEn:(NSString *)nameEn allowDiscount:(NSInteger)allowDiscount color:(NSString *)color orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(MenuType *)menuType;
+(void)removeObject:(MenuType *)menuType;
+(void)addList:(NSMutableArray *)menuTypeList;
+(void)removeList:(NSMutableArray *)menuTypeList;
+(MenuType *)getMenuType:(NSInteger)menuTypeID;
-(BOOL)editMenuType:(MenuType *)editingMenuType;
+(MenuType *)copyFrom:(MenuType *)fromMenuType to:(MenuType *)toMenuType;
+(void)setSharedData:(NSMutableArray *)dataList;
+(NSMutableArray *)getMenuTypeList;
+(NSMutableArray *)sortList:(NSMutableArray *)menuTypeList;
+(NSMutableArray * )getMenuTypeListWithBranchID:(NSInteger)branchID;
//+(NSMutableArray * )getMenuTypeListALarCarteWithBranchID:(NSInteger)branchID;
+(MenuType *)getMenuType:(NSInteger)menuTypeID branchID:(NSInteger)branchID;
+(NSMutableArray *)getMenuTypeListWithMenuList:(NSMutableArray *)menuList;
@end
