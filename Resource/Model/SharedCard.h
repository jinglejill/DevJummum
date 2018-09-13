//
//  SharedCard.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 12/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedCard : NSObject
@property (retain, nonatomic) NSMutableArray *cardList;

+ (SharedCard *)sharedCard;
@end
