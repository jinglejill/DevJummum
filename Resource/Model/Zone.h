//
//  Zone.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 17/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Zone : NSObject
@property (nonatomic) NSInteger zoneID;
@property (retain, nonatomic) NSString * name;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;


@property (nonatomic) NSInteger branchID;


- (NSDictionary *)dictionary;
-(Zone *)initWithName:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(Zone *)zone;
+(void)removeObject:(Zone *)zone;
+(void)addList:(NSMutableArray *)zoneList;
+(void)removeList:(NSMutableArray *)zoneList;
+(Zone *)getZone:(NSInteger)zoneID;
-(BOOL)editZone:(Zone *)editingZone;
+(Zone *)copyFrom:(Zone *)fromZone to:(Zone *)toZone;

@end

NS_ASSUME_NONNULL_END
