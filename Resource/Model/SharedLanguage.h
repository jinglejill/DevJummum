//
//  SharedLanguage.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 18/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedLanguage : NSObject
@property (retain, nonatomic) NSMutableArray *languageList;

+ (SharedLanguage *)sharedLanguage;
@end
