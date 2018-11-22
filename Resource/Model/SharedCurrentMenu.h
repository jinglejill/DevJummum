//
//  SharedCurrentMenu.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 12/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuForAlacarte.h"

@interface SharedCurrentMenu : NSObject
@property (retain, nonatomic) MenuForAlacarte *menuForAlacarte;

+ (SharedCurrentMenu *)SharedCurrentMenu;
@end
