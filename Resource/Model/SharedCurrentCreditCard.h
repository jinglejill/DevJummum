//
//  SharedCurrentCreditCard.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 5/8/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreditCard.h"


@interface SharedCurrentCreditCard : NSObject
@property (retain, nonatomic) CreditCard *creditCard;

+ (SharedCurrentCreditCard *)sharedCurrentCreditCard;
@end
