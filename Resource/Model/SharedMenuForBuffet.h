//
//  SharedMenuForBuffet.h
//  DemoJummum
//
//  Created by Thidaporn Kijkamjai on 25/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuForBuffet.h"


@interface SharedMenuForBuffet : NSObject
@property (retain, nonatomic) MenuForBuffet *menuForBuffet;
    
+ (SharedMenuForBuffet *)sharedMenuForBuffet;
@end
