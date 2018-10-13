//
//  FirstTimeInstall.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 12/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstTimeInstall : NSObject
@property (retain, nonatomic) NSString * username;
@property (nonatomic) NSInteger intalled;


- (NSDictionary *)dictionary;
@end
