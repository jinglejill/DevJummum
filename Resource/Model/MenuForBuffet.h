//
//  MenuForBuffet.h
//  DemoJummum
//
//  Created by Thidaporn Kijkamjai on 25/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuForBuffet : NSObject
@property (nonatomic) NSInteger receiptID;
@property (retain, nonatomic) NSMutableArray *menuList;
@property (retain, nonatomic) NSMutableArray *menuTypeList;
-(MenuForBuffet *)initWithReceiptID:(NSInteger)receiptID menuList:(NSMutableArray *)menuList menuTypeList:(NSMutableArray *)menuTypeList;
@end
