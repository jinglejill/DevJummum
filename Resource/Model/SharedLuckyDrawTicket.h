//
//  SharedLuckyDrawTicket.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 8/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedLuckyDrawTicket : NSObject
@property (retain, nonatomic) NSMutableArray *luckyDrawTicketList;

+ (SharedLuckyDrawTicket *)sharedLuckyDrawTicket;
@end
