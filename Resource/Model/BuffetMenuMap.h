//
//  BuffetMenuMap.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 1/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuffetMenuMap : NSObject
@property (nonatomic) NSInteger buffetMenuMapID;
@property (nonatomic) NSInteger buffetMenuID;
@property (nonatomic) NSInteger menuID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;
    
    
@property (nonatomic) NSInteger branchID;
    
-(BuffetMenuMap *)initWithBuffetMenuID:(NSInteger)buffetMenuID menuID:(NSInteger)menuID;
+(NSInteger)getNextID;
+(void)addObject:(BuffetMenuMap *)buffetMenuMap;
+(void)removeObject:(BuffetMenuMap *)buffetMenuMap;
+(void)addList:(NSMutableArray *)buffetMenuMapList;
+(void)removeList:(NSMutableArray *)buffetMenuMapList;
+(BuffetMenuMap *)getBuffetMenuMap:(NSInteger)buffetMenuMapID;
-(BOOL)editBuffetMenuMap:(BuffetMenuMap *)editingBuffetMenuMap;
+(BuffetMenuMap *)copyFrom:(BuffetMenuMap *)fromBuffetMenuMap to:(BuffetMenuMap *)toBuffetMenuMap;
 
    

@end
