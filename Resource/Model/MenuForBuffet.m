//
//  MenuForBuffet.m
//  DemoJummum
//
//  Created by Thidaporn Kijkamjai on 25/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "MenuForBuffet.h"

@implementation MenuForBuffet
-(MenuForBuffet *)initWithReceiptID:(NSInteger)receiptID menuList:(NSMutableArray *)menuList menuTypeList:(NSMutableArray *)menuTypeList
{
    self = [super init];
    if(self)
    {
        self.receiptID = receiptID;
        self.menuList = menuList;
        self.menuTypeList = menuTypeList;
    }
    return self;
}
@end
