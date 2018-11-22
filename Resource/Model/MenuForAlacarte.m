//
//  MenuForAlacarte.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 19/11/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "MenuForAlacarte.h"

@implementation MenuForAlacarte
-(MenuForAlacarte *)initWithBranchID:(NSInteger)branchID menuList:(NSMutableArray *)menuList menuTypeList:(NSMutableArray *)menuTypeList;
{
    self = [super init];
    if(self)
    {
        self.branchID = branchID;
        self.menuList = menuList;
        self.menuTypeList = menuTypeList;        
    }
    return self;
}
@end
