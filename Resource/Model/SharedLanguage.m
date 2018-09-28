//
//  SharedLanguage.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 18/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedLanguage.h"

@implementation SharedLanguage
@synthesize languageList;

+(SharedLanguage *)sharedLanguage {
    static dispatch_once_t pred;
    static SharedLanguage *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedLanguage alloc] init];
        shared.languageList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
