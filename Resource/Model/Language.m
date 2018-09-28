//
//  Language.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 18/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "Language.h"
#import "SharedLanguage.h"
@implementation Language


-(Language *)initWithLanguageID:(NSInteger)languageID code:(NSString *)code
{
    self = [super init];
    if(self)
    {
        self.languageID = languageID;
        self.code = code;        
    }
    return self;
}

+(void)setSupportLanguage
{
    {
        Language *language = [[Language alloc]initWithLanguageID:1 code:@"TH"];
        [[SharedLanguage sharedLanguage].languageList addObject:language];
    }
    {
        Language *language = [[Language alloc]initWithLanguageID:2 code:@"EN"];
        [[SharedLanguage sharedLanguage].languageList addObject:language];
    }
    
}

+(void)setLanguage:(NSString *)code
{
    [[NSUserDefaults standardUserDefaults] setValue:code forKey:@"language"];
}

+(NSString *)getLanguage
{
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
    if(!language)
    {
        language = @"TH";
    }
    return language;
}

+(NSString *)getText:(NSString *)key
{
    NSString *language = [self getLanguage];
    NSString *fileName = [[NSBundle mainBundle] pathForResource:language ofType:@"strings"];
    NSDictionary *dicLanguage = [NSDictionary dictionaryWithContentsOfFile:fileName];
    NSString *text = [dicLanguage objectForKey:key];
    if(!text)
    {
        text = key;
    }
    return text;
}

+(BOOL)langIsEN
{
    return [[self getLanguage] isEqualToString:@"EN"];
}

+(BOOL)langIsTH
{
    return [[self getLanguage] isEqualToString:@"TH"];
}
@end
