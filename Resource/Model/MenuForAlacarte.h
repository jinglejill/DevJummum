//
//  MenuForAlacarte.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 19/11/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuForAlacarte : NSObject
@property (nonatomic) NSInteger branchID;
@property (retain, nonatomic) NSMutableArray *menuList;
@property (retain, nonatomic) NSMutableArray *menuTypeList;
-(MenuForAlacarte *)initWithBranchID:(NSInteger)branchID menuList:(NSMutableArray *)menuList menuTypeList:(NSMutableArray *)menuTypeList;
@end
