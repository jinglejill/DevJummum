//
//  Language.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 18/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject
@property (nonatomic) NSInteger languageID;
@property (retain, nonatomic) NSString * code;

-(Language *)initWithLanguageID:(NSInteger)languageID code:(NSString *)code;
+(void)setSupportLanguage;
+(void)setLanguage:(NSString *)code;
+(NSString *)getLanguage;
+(NSString *)getText:(NSString *)key;
+(BOOL)langIsEN;
+(BOOL)langIsTH;
@end
