//
//  SharedZone.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 17/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharedZone : NSObject
@property (retain, nonatomic) NSMutableArray *zoneList;

+ (SharedZone *)sharedZone;
@end

NS_ASSUME_NONNULL_END
