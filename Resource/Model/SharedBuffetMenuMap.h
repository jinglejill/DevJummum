//
//  SharedBuffetMenuMap.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 1/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedBuffetMenuMap : NSObject
@property (retain, nonatomic) NSMutableArray *buffetMenuMapList;
    
+ (SharedBuffetMenuMap *)sharedBuffetMenuMap;
@end
