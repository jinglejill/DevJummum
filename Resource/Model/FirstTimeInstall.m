//
//  FirstTimeInstall.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 12/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "FirstTimeInstall.h"

@implementation FirstTimeInstall
- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"username"]?[self valueForKey:@"username"]:[NSNull null],@"username",
        [self valueForKey:@"installed"]?[self valueForKey:@"installed"]:[NSNull null],@"installed",
        nil];
}
@end
