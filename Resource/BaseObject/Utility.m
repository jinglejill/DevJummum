//
//  Utility.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Utility.h"
#import <objc/runtime.h>
#import "UserAccount.h"
#import "LogIn.h"
#import "SharedUserAccount.h"
#import "SharedLogIn.h"
//#import "NSData+Encryption.h"
#import "NSData+AES.h"



extern NSArray *globalMessage;
extern NSString *globalPingAddress;
extern NSString *globalDomainName;
extern NSString *globalSubjectNoConnection;
extern NSString *globalDetailNoConnection;
extern BOOL globalFinishLoadSharedData;
extern NSString *globalKey;
extern NSString *globalModifiedUser;



@implementation Utility
+ (NSString *) randomStringWithLength: (int) len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])] ];
    }
    
    return randomString;
}

+ (NSString *) randomStringWithLength: (int) len letters:(NSString *)letters
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])] ];
    }
    
    return randomString;
}

+(NSString *)randomStrongPassword
{
    NSString *lettersCap = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *lettersNonCap = @"abcdefghijklmnopqrstuvwxyz";
    NSString *lettersNumber = @"0123456789";
    NSString *lettersAll = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    
    
    NSString *password = [self randomStringWithLength:1 letters:lettersCap];
    password = [NSString stringWithFormat:@"%@%@",password,[self randomStringWithLength:1 letters:lettersNonCap]];
    password = [NSString stringWithFormat:@"%@%@",password,[self randomStringWithLength:1 letters:lettersNumber]];
    password = [NSString stringWithFormat:@"%@%@",password,[self randomStringWithLength:5 letters:lettersAll]];
    
    return password;
    
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
//    NSString *emailRegex = @"\\w+@[a-zA-Z_]+?\\.[a-zA-Z]{2,6}";
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (void) setPingAddress:(NSString *)pingAddress
{
    globalPingAddress = pingAddress;
}

+ (NSString *) pingAddress
{
    return globalPingAddress;
}

+ (void) setDomainName:(NSString *)domainName
{
    globalDomainName = domainName;
}

+ (NSString *) domainName
{
    return globalDomainName;
}

+ (void) setSubjectNoConnection:(NSString *)subjectNoConnection
{
    globalSubjectNoConnection = subjectNoConnection;
}

+ (NSString *) subjectNoConnection
{
    return globalSubjectNoConnection;
}

+ (void) setDetailNoConnection:(NSString *)detailNoConnection
{
    globalDetailNoConnection = detailNoConnection;
}

+ (NSString *) detailNoConnection
{
    return globalDetailNoConnection;
}

+(void)setKey:(NSString *)key
{
    globalKey = key;
}
+(NSString *)key
{
    return globalKey;
}

+ (NSString *) deviceToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:TOKEN];
}

+ (NSInteger) deviceID
{
    NSString *strDeviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceID"];
    return [strDeviceID integerValue];
}

+ (NSString *) dbName
{
//    return [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
    return [[NSUserDefaults standardUserDefaults] stringForKey:BRANCH];
}

+ (BOOL) finishLoadSharedData
{
    return globalFinishLoadSharedData;
}

+ (void) setFinishLoadSharedData:(BOOL)finish
{
    globalFinishLoadSharedData = finish;
}

+ (NSString *) url:(enum enumUrl)eUrl
{
    NSString *url = [[NSString alloc]init];
    switch (eUrl)
    {
        case urlSendEmail:
            url = @"/DEV/DEV_JUMMUM/sendEmail.php";
            break;
        case urlUploadPhoto:
            url = @"/DEV/DEV_JUMMUM/uploadPhoto.php";
            break;
        case urlDownloadPhoto:
            url = @"/DEV/DEV_JUMMUM/downloadImage.php";
            break;
        case urlDownloadFile:
            url = @"/DEV/DEV_JUMMUM/downloadFile.php";
            break;
        case urlUserAccountDeviceTokenUpdate:
            url = @"/DEV/DEV_JUMMUM/FFDUserAccountDeviceTokenUpdate.php";
            break;
        case urlPushSyncSync:
            url = @"/DEV/DEV_JUMMUM/JMMPushSyncSync.php";
            break;
        case urlPushSyncUpdateByDeviceToken:
            url = @"/DEV/DEV_JUMMUM/JMMPushSyncUpdateByDeviceToken.php";
            break;
        case urlDeviceInsert:
            url = @"/DEV/DEV_JUMMUM/FFDDeviceInsert.php";
            break;
        case urlPushSyncUpdateTimeSynced:
            url = @"/DEV/DEV_JUMMUM/JMMPushSyncUpdateTimeSynced.php";
            break;
        case urlMasterGet:
            url = @"/DEV/DEV_JUMMUM/JMMMasterGet.php";
            break;
        case urlLogInInsert:
            url = @"/DEV/DEV_JUMMUM/JMMLogInInsert.php";
            break;
        case urlLogInUserAccountInsert:
            url = @"/DEV/DEV_JUMMUM/JMMLogInUserAccountInsert.php";
            break;
        case urlLogOutInsert:
            url = @"/DEV/DEV_JUMMUM/JMMLogOutInsert.php";
            break;
        case urlWriteLog:
            url = @"/DEV/DEV_JUMMUM/JMMWriteLog.php";
            break;
        case urlMenuInsert:
            url = @"/DEV/DEV_JUMMUM/JMMMenuInsert.php";
            break;
        case urlMenuUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMMenuUpdate.php";
            break;
        case urlMenuDelete:
            url = @"/DEV/DEV_JUMMUM/JMMMenuDelete.php";
            break;
        case urlMenuInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMMenuInsertList.php";
            break;
        case urlMenuUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMMenuUpdateList.php";
            break;
        case urlMenuDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMMenuDeleteList.php";
            break;
        case urlMenuGetList:
            url = @"/DEV/DEV_JUMMUM/JMMMenuGetList.php";
            break;
        case urlMenuNoteGetList:
            url = @"/DEV/DEV_JUMMUM/JMMMenuNoteGetList.php";
            break;
        case urlPicInsert:
            url = @"/DEV/DEV_JUMMUM/JMMPicInsert.php";
            break;
        case urlPicUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMPicUpdate.php";
            break;
        case urlPicDelete:
            url = @"/DEV/DEV_JUMMUM/JMMPicDelete.php";
            break;
        case urlPicInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMPicInsertList.php";
            break;
        case urlPicUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMPicUpdateList.php";
            break;
        case urlPicDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMPicDeleteList.php";
            break;
        case urlMenuPicInsert:
            url = @"/DEV/DEV_JUMMUM/JMMMenuPicInsert.php";
            break;
        case urlMenuPicUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMMenuPicUpdate.php";
            break;
        case urlMenuPicDelete:
            url = @"/DEV/DEV_JUMMUM/JMMMenuPicDelete.php";
            break;
        case urlMenuPicInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMMenuPicInsertList.php";
            break;
        case urlMenuPicUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMMenuPicUpdateList.php";
            break;
        case urlMenuPicDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMMenuPicDeleteList.php";
            break;
        case urlOmiseCheckOut:
            url = @"/DEV/DEV_JUMMUM/OmiseCheckOut.php";
            break;
        case urlReceiptOrderTakingOrderNoteInsert:
            url = @"/DEV/DEV_JUMMUM/JMMReceiptOrderTakingOrderNoteInsert.php";
            break;
        case urlCustomerTableGetList:
            url = @"/DEV/DEV_JUMMUM/JMMCustomerTableGetList.php";
            break;
        case urlReceiptSummaryGetList:
            url = @"/DEV/DEV_JUMMUM/JMMReceiptSummaryGetList.php";
            break;
        case urlPromotionGetList:
            url = @"/DEV/DEV_JUMMUM/JMMPromotionGetList.php";
            break;
        case urlFacebookComment:
            url = @"/DEV/DEV_JUMMUM/FacebookCommentInsertList.php";
            break;
        case urlUserAccountValidate:
            url = @"/DEV/DEV_JUMMUM/JMMUserAccountValidate.php";
            break;
        case urlUserAccountGet:
            url = @"/DEV/DEV_JUMMUM/JMMUserAccountGet.php";
            break;
        case urlUserAccountInsert:
            url = @"/DEV/DEV_JUMMUM/JMMUserAccountInsert.php";
            break;
        case urlUserAccountUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMUserAccountUpdate.php";
            break;
        case urlTermsOfService:
            url = @"/DEV/DEV_JUMMUM/HtmlTermsOfService.php";
            break;
        case urlContactUs:
            url = @"/DEV/DEV_JUMMUM/HtmlContactUs.php";
            break;
        case urlUserAccountForgotPasswordInsert:
            url = @"/DEV/DEV_JUMMUM/JMMUserAccountForgotPasswordInsert.php";
            break;
        case urlRewardPointInsert:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointInsert.php";
            break;
        case urlRewardPointUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointUpdate.php";
            break;
        case urlRewardPointDelete:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointDelete.php";
            break;
        case urlRewardPointInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointInsertList.php";
            break;
        case urlRewardPointUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointUpdateList.php";
            break;
        case urlRewardPointDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointDeleteList.php";
            break;
        case urlRewardPointGet:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointGet.php";
            break;
        case urlPrivacyPolicy:
            url = @"/DEV/DEV_JUMMUM/HtmlPrivacyPolicy.php";
            break;
        case urlPushReminder:
            url = @"/DEV/DEV_JUMMUM/JMMPushReminder.php";
            break;
        case urlHotDealInsert:
            url = @"/DEV/DEV_JUMMUM/JMMHotDealInsert.php";
            break;
        case urlHotDealUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMHotDealUpdate.php";
            break;
        case urlHotDealDelete:
            url = @"/DEV/DEV_JUMMUM/JMMHotDealDelete.php";
            break;
        case urlHotDealInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMHotDealInsertList.php";
            break;
        case urlHotDealUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMHotDealUpdateList.php";
            break;
        case urlHotDealDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMHotDealDeleteList.php";
            break;
        case urlHotDealGetList:
            url = @"/DEV/DEV_JUMMUM/JMMHotDealGetList.php";
            break;
        case urlRewardRedemptionInsert:
            url = @"/DEV/DEV_JUMMUM/JMMRewardRedemptionInsert.php";
            break;
        case urlRewardRedemptionUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMRewardRedemptionUpdate.php";
            break;
        case urlRewardRedemptionDelete:
            url = @"/DEV/DEV_JUMMUM/JMMRewardRedemptionDelete.php";
            break;
        case urlRewardRedemptionInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardRedemptionInsertList.php";
            break;
        case urlRewardRedemptionUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardRedemptionUpdateList.php";
            break;
        case urlRewardRedemptionDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardRedemptionDeleteList.php";
            break;
        case urlPromoCodeInsert:
            url = @"/DEV/DEV_JUMMUM/JMMPromoCodeInsert.php";
            break;
        case urlPromoCodeUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMPromoCodeUpdate.php";
            break;
        case urlPromoCodeDelete:
            url = @"/DEV/DEV_JUMMUM/JMMPromoCodeDelete.php";
            break;
        case urlPromoCodeInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMPromoCodeInsertList.php";
            break;
        case urlPromoCodeUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMPromoCodeUpdateList.php";
            break;
        case urlPromoCodeDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMPromoCodeDeleteList.php";
            break;
        case urlRewardPointSpentGetList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointSpentGetList.php";
            break;
        case urlRewardPointSpentMoreGetList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointSpentMoreGetList.php";
            break;
        case urlRewardPointSpentUsedGetList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointSpentUsedGetList.php";
            break;
        case urlRewardPointSpentUsedMoreGetList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointSpentUsedMoreGetList.php";
            break;
        case urlRewardPointSpentExpiredGetList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointSpentExpiredGetList.php";
            break;
        case urlRewardPointSpentExpiredMoreGetList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardPointSpentExpiredMoreGetList.php";
            break;
        case urlUserRewardRedemptionUsedInsert:
            url = @"/DEV/DEV_JUMMUM/JMMUserRewardRedemptionUsedInsert.php";
            break;
        case urlUserRewardRedemptionUsedUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMUserRewardRedemptionUsedUpdate.php";
            break;
        case urlUserRewardRedemptionUsedDelete:
            url = @"/DEV/DEV_JUMMUM/JMMUserRewardRedemptionUsedDelete.php";
            break;
        case urlUserRewardRedemptionUsedInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMUserRewardRedemptionUsedInsertList.php";
            break;
        case urlUserRewardRedemptionUsedUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMUserRewardRedemptionUsedUpdateList.php";
            break;
        case urlUserRewardRedemptionUsedDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMUserRewardRedemptionUsedDeleteList.php";
            break;
        case urlReceiptMaxModifiedDateGetList:
            url = @"/DEV/DEV_JUMMUM/JMMReceiptMaxModifiedDateGetList.php";
            break;
        case urlReceiptWithModifiedDateGet:
            url = @"/DEV/DEV_JUMMUM/JMMReceiptWithModifiedDateGet.php";
            break;
        case urlReceiptGet:
            url = @"/DEV/DEV_JUMMUM/JMMReceiptGet.php";
            break;
        case urlDisputeReasonInsert:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeReasonInsert.php";
            break;
        case urlDisputeReasonUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeReasonUpdate.php";
            break;
        case urlDisputeReasonDelete:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeReasonDelete.php";
            break;
        case urlDisputeReasonInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeReasonInsertList.php";
            break;
        case urlDisputeReasonUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeReasonUpdateList.php";
            break;
        case urlDisputeReasonDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeReasonDeleteList.php";
            break;
        case urlDisputeReasonGetList:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeReasonGetList.php";
            break;
        case urlDisputeInsert:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeInsert.php";
            break;
        case urlDisputeUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeUpdate.php";
            break;
        case urlDisputeDelete:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeDelete.php";
            break;
        case urlDisputeInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeInsertList.php";
            break;
        case urlDisputeUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeUpdateList.php";
            break;
        case urlDisputeDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeDeleteList.php";
            break;
        case urlDisputeGetList:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeGetList.php";
            break;
        case urlDisputeCancelInsert:
            url = @"/DEV/DEV_JUMMUM/JMMDisputeCancelInsert.php";
            break;
        case urlReceiptUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMReceiptUpdate.php";
            break;
        case urlBranchGetList:
            url = @"/DEV/DEV_JUMMUM/JMMBranchGetList.php";
            break;
        case urlBranchAndCustomerTableGet:
            url = @"/DEV/DEV_JUMMUM/JMMBranchAndCustomerTableGet.php";
            break;
        case urlBranchAndCustomerTableQRGet:
            url = @"/DEV/DEV_JUMMUM/JMMBranchAndCustomerTableQRGet.php";
            break;
        case urlBranchSearchGetList:
            url = @"/DEV/DEV_JUMMUM/JMMBranchSearchGetList.php";
            break;
        case urlBranchSearchMoreGetList:
            url = @"/DEV/DEV_JUMMUM/JMMBranchSearchMoreGetList.php";
            break;
        case urlHotDealWithBranchGetList:
            url = @"/DEV/DEV_JUMMUM/JMMHotDealWithBranchIDGetList.php";
            break;
        case urlRewardRedemptionWithBranchGetList:
            url = @"/DEV/DEV_JUMMUM/JMMRewardRedemptionWithBranchIDGetList.php";
            break;
        case urlCommentInsert:
            url = @"/DEV/DEV_JUMMUM/JMMCommentInsert.php";
            break;
        case urlCommentUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMCommentUpdate.php";
            break;
        case urlCommentDelete:
            url = @"/DEV/DEV_JUMMUM/JMMCommentDelete.php";
            break;
        case urlCommentInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMCommentInsertList.php";
            break;
        case urlCommentUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMCommentUpdateList.php";
            break;
        case urlCommentDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMCommentDeleteList.php";
            break;
        case urlRecommendShopInsert:
            url = @"/DEV/DEV_JUMMUM/JMMRecommendShopInsert.php";
            break;
        case urlRecommendShopUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMRecommendShopUpdate.php";
            break;
        case urlRecommendShopDelete:
            url = @"/DEV/DEV_JUMMUM/JMMRecommendShopDelete.php";
            break;
        case urlRecommendShopInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMRecommendShopInsertList.php";
            break;
        case urlRecommendShopUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMRecommendShopUpdateList.php";
            break;
        case urlRecommendShopDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMRecommendShopDeleteList.php";
            break;
        case urlRatingInsert:
            url = @"/DEV/DEV_JUMMUM/JMMRatingInsert.php";
            break;
        case urlRatingUpdate:
            url = @"/DEV/DEV_JUMMUM/JMMRatingUpdate.php";
            break;
        case urlRatingDelete:
            url = @"/DEV/DEV_JUMMUM/JMMRatingDelete.php";
            break;
        case urlRatingInsertList:
            url = @"/DEV/DEV_JUMMUM/JMMRatingInsertList.php";
            break;
        case urlRatingUpdateList:
            url = @"/DEV/DEV_JUMMUM/JMMRatingUpdateList.php";
            break;
        case urlRatingDeleteList:
            url = @"/DEV/DEV_JUMMUM/JMMRatingDeleteList.php";
            break;
        case urlReceiptDisputeRatingGet:
            url = @"/DEV/DEV_JUMMUM/JMMReceiptDisputeRatingGet.php";
            break;
        case urlReceiptDisputeRatingAllAfterReceiptGet:
            url = @"/DEV/DEV_JUMMUM/JMMReceiptDisputeRatingAllAfterReceiptGet.php";
            break;
        case urlOpeningTimeGet:
            url = @"/DEV/DEV_JUMMUM/JMMOpeningTimeGet.php";
            break;
        case urlMenuBelongToBuffetGetList:
            url = @"/DEV/DEV_JUMMUM/JMMMenuBelongToBuffetGetList.php";
            break;
        default:
            break;
    }
    url = [NSString stringWithFormat:@"%@%@", [self domainName],url];
    return url;
}

+ (NSString *) appendRandomParam:(NSString *)url
{
    return [NSString stringWithFormat:@"%@?%@&",url,[Utility randomStringWithLength:6]];
}

+ (NSString *) formatDate:(NSString *)strDate fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];//local time +7
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = fromFormat;
    NSDate *date  = [df dateFromString:strDate];
    
    // Convert to new Date Format
    [df setDateFormat:toFormat];///////uncomment dont forget
    
    //must set timezone to normal
    NSString *newStrDate = [df stringFromDate:date];
    return newStrDate;
}

+ (nullable NSDate *) stringToDate:(NSString *)strDate fromFormat:(NSString *)fromFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];//local time +7
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = fromFormat;
    
    NSDate *date = [df dateFromString:strDate];
    return date;
}

+ (NSString *) dateToString:(NSDate *)date toFormat:(NSString *)toFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];//local time +7
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = toFormat;
    
    
    NSString *strDate = [df stringFromDate:date];
    if(!strDate)
    {
        strDate = @"";
    }
    return strDate;
}

+ (NSDate *) setDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    return date;
}

+(NSString *)modifiedUser
{
    return globalModifiedUser;
}

+(void)setModifiedUser:(NSString *)modifiedUser
{
    globalModifiedUser = modifiedUser;
}

+ (NSInteger) numberOfDaysFromDate:(NSDate *)dateFrom dateTo:(NSDate *)dateTo
{
    NSTimeInterval secondsBetween = [dateTo timeIntervalSinceDate:dateFrom];
    int numberOfDays = secondsBetween / 86400 + 1;
    return numberOfDays;
}

+ (NSDate *) dateFromDateTime:(NSDate *)dateTime
{
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay
                                    fromDate:dateTime];
    NSDate *date = [[NSCalendar currentCalendar]
                    dateFromComponents:components];
    
    return date;
}

+ (NSInteger) dayFromDateTime:(NSDate *)dateTime
{
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay
                                    fromDate:dateTime];
    
    NSInteger day = [components day];
    return day;
}

+ (NSDate *) GMTDate:(NSDate *)dateTime
{
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateTimeInLocalTimezone = [dateTime dateByAddingTimeInterval:timeZoneSeconds];
    
    return dateTimeInLocalTimezone;
}

+ (NSDate *) currentDateTime
{
    return [Utility GMTDate:[NSDate date]];
}

+ (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

+ (NSString *)concatParameter:(NSDictionary *)condition
{
    NSString *value;
    NSString *urlParameter = @"";
    for(id key in condition)
    {
        value = [condition objectForKey:key];
        urlParameter = [NSString stringWithFormat:@"%@&%@=%@",urlParameter,key,value];
    }
    
    NSRange needleRange = NSMakeRange(1,[urlParameter length]-1);
    urlParameter = [urlParameter substringWithRange:needleRange];
    
    return urlParameter;
}

+ (NSString *) getNoteDataString: (NSObject *)object
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")]  && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString;
            if(![value isEqual:[NSNull null]] && [value length]>0)
            {
                trimString = [Utility trimString:escapeString];
            }
            else
            {
                trimString = @"";
            }
            
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        
        [dicCondition setValue:escapeString forKey:key];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}

+ (NSString *) getNoteDataString: (NSObject *)object withRunningNo:(long)runningNo
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")] && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString = [Utility trimString:escapeString];
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        key = [NSString stringWithFormat:@"%@%02ld",key,runningNo];
        [dicCondition setValue:escapeString forKey:key];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}

+ (NSString *) getNoteDataString: (NSObject *)object withRunningNo3Digit:(long)runningNo
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")] && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString = [Utility trimString:escapeString];
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        key = [NSString stringWithFormat:@"%@%03ld",key,runningNo];
        [dicCondition setValue:escapeString forKey:key];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}
+ (NSString *) getNoteDataString: (NSObject *)object withPrefix:(NSString *)prefix
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")]  && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString;
            if(![value isEqual:[NSNull null]] && [value length]>0)
            {
                trimString = [Utility trimString:escapeString];
            }
            else
            {
                trimString = @"";
            }
            
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        
        NSString *keyWithPrefix = [NSString stringWithFormat:@"%@%@",prefix,[self makeFirstLetterUpperCase:key]];
        [dicCondition setValue:escapeString forKey:keyWithPrefix];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}
+ (NSString *) getNoteDataString: (NSObject *)object withPrefix:(NSString *)prefix runningNo:(long)runningNo
{
    NSMutableDictionary *dicCondition = [[NSMutableDictionary alloc]init];
    
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")] && ![value isKindOfClass:NSClassFromString(@"__NSCFBoolean")] && ![value isKindOfClass:NSClassFromString(@"__NSTaggedDate")]  && ![value isKindOfClass:NSClassFromString(@"__NSDate")]){//__NSCFConstantString //__NSCFNumber  //__NSCFString //
            NSString *trimString;
            if(![value isEqual:[NSNull null]] && [value length]>0)
            {
                trimString = [Utility trimString:escapeString];
            }
            else
            {
                trimString = @"";
            }
            
            escapeString = [self percentEscapeString:trimString];//สำหรับส่ง ให้ php script
        }
        
        NSString *keyWithPrefix = [NSString stringWithFormat:@"%@%@%02ld",prefix,[self makeFirstLetterUpperCase:key],runningNo];
        [dicCondition setValue:escapeString forKey:keyWithPrefix];
    }
    free(properties);
    
    return [self concatParameter:dicCondition];
}
+ (NSObject *) trimAndFixEscapeString: (NSObject *)object
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        
        id value = [object valueForKey:key];
        
        NSString *escapeString = value;
        if(![value isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            NSString *trimString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            escapeString = [self percentEscapeString:trimString];
        }
        [object setValue:escapeString forKey:key];
    }
    free(properties);
    
    return object;
}

+ (NSString *)formatDecimal:(float)number
{
    NSNumberFormatter *formatterBaht = [[NSNumberFormatter alloc]init];
    [formatterBaht setNumberStyle:NSNumberFormatterDecimalStyle];
    formatterBaht.minimumFractionDigits = 0;
    formatterBaht.maximumFractionDigits = 2;
    NSString *strFormattedBaht = [formatterBaht stringFromNumber:[NSNumber numberWithFloat:number]];
    return strFormattedBaht;
}

+ (NSString *)formatDecimal:(float)number withMinFraction:(NSInteger)min andMaxFraction:(NSInteger)max
{
    NSNumberFormatter *formatterBaht = [[NSNumberFormatter alloc]init];
    [formatterBaht setNumberStyle:NSNumberFormatterDecimalStyle];
    formatterBaht.minimumFractionDigits = min;
    formatterBaht.maximumFractionDigits = max;
    NSString *strFormattedBaht = [formatterBaht stringFromNumber:[NSNumber numberWithFloat:number]];
    return strFormattedBaht;
}

+ (NSString *)trimString:(NSString *)text
{
    if([text length] != 0)
    {
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return text;
}

+ (NSString *)setPhoneNoFormat:(NSString *)text
{
    if(!text)
    {
        return @"";
    }
    if([text length] == 10)
    {
        NSMutableString *mu = [NSMutableString stringWithString:text];
        [mu insertString:@"-" atIndex:3];
        [mu insertString:@"-" atIndex:7];
        return [NSString stringWithString:mu];
    }
    else if([text length] > 10)
    {
        NSString *strPhoneNo = @"";
        if([text rangeOfString:@","].location != NSNotFound)
        {
            NSArray *arrPhoneNo = [text componentsSeparatedByString:@","];
            for(int i=0; i<[arrPhoneNo count]; i++)
            {
                if(i==0)
                {
                    strPhoneNo = [self setPhoneNoFormat:arrPhoneNo[i]];
                }
                else
                {
                    strPhoneNo = [NSString stringWithFormat:@"%@,%@",strPhoneNo,[self setPhoneNoFormat:arrPhoneNo[i]]];
                }
            }
            return strPhoneNo;
        }
    }
    return text;
}
+ (NSString *)removeDashAndSpaceAndParenthesis:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@")" withString:@""];
    return text;
}
+ (NSString *)removeComma:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
    return text;
}
+ (NSString *)removeApostrophe:(NSString *)text
{
    text = [text stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return text;
}
+ (NSString *)removeKeyword:(NSArray *)arrKeyword text:(NSString *)text
{
    for(NSString *keyword in arrKeyword)
    {
        text = [text stringByReplacingOccurrencesOfString:keyword withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [text length])];
    }
    
    return text;
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    NSInteger length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

+ (NSString *)makeFirstLetterLowerCase:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *theRestLetters = [text substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@",[firstLetter lowercaseString],theRestLetters];
}

+ (NSString *)makeFirstLetterUpperCase:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *theRestLetters = [text substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@",[firstLetter uppercaseString],theRestLetters];
}

+ (NSString *)makeFirstLetterUpperCaseOtherLower:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *theRestLetters = [text substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@",[firstLetter uppercaseString],[theRestLetters lowercaseString]];
}

+ (NSString *)getPrimaryKeyFromClassName:(NSString *)className
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [className substringWithRange:needleRange];
    needleRange = NSMakeRange(1,[className length]-1);
    NSString *theRestLetter = [className substringWithRange:needleRange];
    return [NSString stringWithFormat:@"%@%@ID",[firstLetter lowercaseString],theRestLetter];
}

+ (NSString *)getMasterClassName:(NSInteger)i
{
    NSArray *arrMasterClass = @[@"Setting"];
    
    
    return arrMasterClass[i];
}

+ (NSString *)getMasterClassName:(NSInteger)i from:(NSArray *)arrClassName
{
    return arrClassName[i];
}

+ (BOOL)isNumeric:(NSString *)text
{
    if([text isKindOfClass:[NSString class]])
    {
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            // newString consists only of the digits 0 through 9
            return YES;
        }
    }
    
    return NO;
}

+(NSString *)getSqlFailTitle
{
    return @"Error occur";
}
+(NSString *)getSqlFailMessage
{
    return @"Please check recent transactions again";
}

+(NSString *)getErrorOccurTitle
{
//    return @"Connection lost";
    return @"Error occured";
}

+(NSString *)getErrorOccurMessage
{
//    return @"The network connection was lost";
    return @"Please try again. If error still exists, please contact Jummum support";
}

+(NSInteger)getNumberOfRowForExecuteSql
{
    return 30;
}

+(NSInteger)getScanTimeInterVal
{
    return 4;
}

+(NSInteger)getScanTimeInterValCaseBlur
{
    return 2;
}

+ (float)floatValue:(NSString *)text
{
    return [[self removeComma:text] floatValue];
}

+ (NSInteger)getLastDayOfMonth:(NSDate *)datetime;
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange =
    [currentCalendar
     rangeOfUnit:NSCalendarUnitDay
     inUnit:NSCalendarUnitMonth
     forDate:datetime];
    
    // daysRange.length will contain the number of the last day
    // of the month containing curDate
    
    return daysRange.length;
}

+ (BOOL)duplicate:(NSObject *)object
{
    Class classDB = [object class];
    NSString *className = NSStringFromClass(classDB);
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
    NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
    NSInteger value = [[object valueForKey:propertyName] integerValue];
    NSString *modifiedUser = [object valueForKey:@"modifiedUser"];
    
    
    if([className isEqualToString:@"Menu"])
    {
        NSInteger branchID = [[object valueForKey:@"branchID"] integerValue];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld and _modifiedUser = %@ and _branchID = %ld",propertyNamePredicate,value,modifiedUser,branchID];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        
        
        return [filterArray count]>0;
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld and _modifiedUser = %@",propertyNamePredicate,value,modifiedUser];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        
        
        return [filterArray count]>0;
    }
    
}

+ (BOOL)duplicateID:(NSObject *)object
{
    Class classDB = [object class];
    NSString *className = NSStringFromClass(classDB);
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
    NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
    NSInteger value = [[object valueForKey:propertyName] integerValue];
    NSString *modifiedUser = [object valueForKey:@"modifiedUser"];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld",propertyNamePredicate,value];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray count]>0;
}

+ (void)itemsDownloaded:(NSArray *)items
{
    for(int j=0; j<[items count]; j++)
    {
        NSArray *arrTable = items[j];
        if([arrTable count]>0)
        {
            NSObject *object = arrTable[0];
            Class classDB = [object class];
            NSString *className = NSStringFromClass(classDB);
            Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
            SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
            NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
            [dataList removeAllObjects];
            for(NSMutableArray *item in items[j])
            {
                [dataList addObject:item];
            }
        }
    }
}

+ (NSDate *)addDay:(NSDate *)dateFrom numberOfDay:(NSInteger)days
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *addedDate = [theCalendar dateByAddingComponents:dayComponent toDate:dateFrom options:0];
    return addedDate;
}

+ (NSDate *)addSecond:(NSDate *)dateFrom numberOfSecond:(NSInteger)second
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.second = second;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *addedDate = [theCalendar dateByAddingComponents:dayComponent toDate:dateFrom options:0];
    return addedDate;
}

+ (void)setUserDefaultPreOrderEventID:(NSString *) strSelectedEventID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults stringForKey:@"username"];
    NSMutableDictionary *dicPreOrderEventIDByUser = [[defaults dictionaryForKey:@"PreOrderEventIDByUser"] mutableCopy];
    if(!dicPreOrderEventIDByUser)
    {
        dicPreOrderEventIDByUser = [[NSMutableDictionary alloc]init];
    }
    [dicPreOrderEventIDByUser setValue:strSelectedEventID forKey:username];
    [defaults setObject:dicPreOrderEventIDByUser forKey:@"PreOrderEventIDByUser"];
}

+ (NSString *)getUserDefaultPreOrderEventID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults stringForKey:@"username"];
    NSMutableDictionary *dicPreOrderEventIDByUser = [[defaults dictionaryForKey:@"PreOrderEventIDByUser"] mutableCopy];
    if(!dicPreOrderEventIDByUser)
    {
        dicPreOrderEventIDByUser = [[NSMutableDictionary alloc]init];
    }
    NSString *strEventID = [dicPreOrderEventIDByUser objectForKey:username];
    if(!strEventID)
    {
        strEventID = @"0";
        [dicPreOrderEventIDByUser setValue:strEventID forKey:username];
        [defaults setObject:dicPreOrderEventIDByUser forKey:@"PreOrderEventIDByUser"];
    }
    
    
    return strEventID;
    
}

+ (NSArray *)intersectArray1:(NSArray *)array1 array2:(NSArray *)array2
{
    NSMutableSet *set1 = [NSMutableSet setWithArray: array1];
    NSSet *set2 = [NSSet setWithArray: array2];
    [set1 intersectSet: set2];
    NSArray *resultArray = [set1 allObjects];
    return resultArray;
}

+(BOOL)isStringEmpty:(NSString *)text
{
    if(!text || [[Utility trimString:text] isEqualToString:@""])
    {
        return YES;
    }
    return NO;
}

+ (NSDate *)notIdentifiedDate
{
    return [Utility stringToDate:@"1900-01-01 00:00:00" fromFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (BOOL)isDateColumn:(NSString *)columnName
{
    if([columnName length] < 4)
    {
        return NO;
    }
    NSRange needleRange = NSMakeRange([columnName length]-4,4);
    return [[columnName substringWithRange:needleRange] isEqualToString:@"Date"];
}

+ (NSString *)getDay:(NSInteger)dayOfWeekIndex
{
    NSArray *days = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
    return days[dayOfWeekIndex-1];
}

+(NSDate *)getPreviousMonthFirstDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = 1;
    comps.month = -1;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    return  date;
}

+(NSDate *)getPreviousMonthLastDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = 0;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    return date;
    
}

+(NSDate *)getPrevious14Days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = -14;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    
    return date;
}

+(NSDate *)getPreviousOrNextDay:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = days;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:[Utility currentDateTime] options:0];
    
    
    return date;
}

+(NSDate *)getPreviousOrNextDay:(NSInteger)days fromDate:(NSDate *)fromDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = days;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:fromDate options:0];
    
    
    return date;
}

+(NSDate *)getPrevious30Min:(NSDate *)inputDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDateComponents *comps = [NSDateComponents new];
    comps.minute = -30;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:inputDate options:0];
    
    
    return date;
}

+ (void) setExpectedSales:(float)expectedSales
{
    [[NSUserDefaults standardUserDefaults] setFloat:expectedSales forKey:@"expectedSales"];
}

+ (float) expectedSales
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"expectedSales"];
}

+(NSDate *)setStartOfTheDay:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDate *startOfTheDayDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    return startOfTheDayDate;
}

+(NSDate *)setEndOfTheDay:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDate *endOfTheDayDate = [calendar dateBySettingHour:23 minute:59 second:59 ofDate:date options:0];
    return endOfTheDayDate;
}

+(NSDate *)getLatestMonday
{
    NSDate *today = [Utility currentDateTime];
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:today];
    NSInteger weekday = [comps weekday];
    NSInteger days = 0;
    switch (weekday) {
        case 1:
            days = -6;
            break;
        case 2:
            days = 0;
            break;
        case 3:
            days = -1;
            break;
        case 4:
            days = -2;
            break;
        case 5:
            days = -3;
            break;
        case 6:
            days = -4;
            break;
        case 7:
            days = -5;
            break;
        default:
            break;
    }
    
    
    return [self getPreviousOrNextDay:days];
}

+(NSDate *)getNextSunday
{
    return [self getPreviousOrNextDay:6 fromDate:[self getLatestMonday]];
}

+(int)hexStringToInt:(NSString *)hexString
{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&outVal];
    
    return outVal;
}


+(NSArray *)jsonToArray:(NSArray *)arrDataJson arrClassName:(NSArray *)arrClassName
{
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    
    
    for(int i=0; i<[arrDataJson count]; i++)
    {
        //arrdatatemp <= arrdata
        NSMutableArray *arrDataTemp = [[NSMutableArray alloc]init];
        NSArray *arrData = arrDataJson[i];
        for(int j=0; j< arrData.count; j++)
        {
            NSDictionary *jsonElement = arrData[j];
            NSObject *object = [[NSClassFromString([Utility getMasterClassName:i from:arrClassName]) alloc] init];
            
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
            
            for (unsigned int i = 0; i < propertyCount; ++i)
            {
                objc_property_t property = properties[i];
                const char * name = property_getName(property);
                NSString *key = [NSString stringWithUTF8String:name];
                
                
                NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
                if(!jsonElement[dbColumnName])
                {
                    continue;
                }
                
                
                if([Utility isDateColumn:dbColumnName])
                {
                    NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
                    if(!date)
                    {
                        date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd"];
                    }
                    [object setValue:date forKey:key];
                }
                else
                {
                    [object setValue:jsonElement[dbColumnName] forKey:key];
                }
            }
            
            [arrDataTemp addObject:object];
        }
        [arrItem addObject:arrDataTemp];
    }
    
    return arrItem;
}

+(NSMutableArray *)sortDataByColumn:(NSMutableArray *)dataList numOfColumn:(NSInteger)numOfColumn
{
    NSMutableArray *sortDataList = [[NSMutableArray alloc]init];
    NSInteger numOfRowPerColumn = ceilf(1.0*[dataList count]/numOfColumn);
    for(int i=0; i<numOfRowPerColumn; i++)
    {
        for(int j=0; j<numOfColumn; j++)
        {
            if(i+j*numOfRowPerColumn >= [dataList count])
            {
                continue;
            }
            else
            {
                [sortDataList addObject:dataList[i+j*numOfRowPerColumn]];
            }
        }
    }
    return sortDataList;
    
}

+(NSString *)getFirstLetter:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(0,1);
    NSString *firstLetter = [text substringWithRange:needleRange];
    return firstLetter;
}

+(NSString *)getTextOmitFirstLetter:(NSString *)text
{
    NSRange needleRange;
    needleRange = NSMakeRange(1,[text length]-1);
    NSString *resultText = [text substringWithRange:needleRange];
    
    
    return resultText;
}

+(NSString *)removeSpace:(NSString *)text
{
    return [text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(NSString *)replaceNewLineForDB:(NSString *)text
{
    return [text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];//replace ด้วยอะไรก้ได้ ที่ไม่ใช่ new line
}

+(NSString *)replaceNewLineForApp:(NSString *)text
{
    return [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
}

+(NSString *)insertDashForPhoneNo:(NSString *)text
{
    int i=0;
    NSString *strPhoneNo;
    NSArray* phoneNoList = [text componentsSeparatedByString: @","];
    for(NSString *item in phoneNoList)
    {
        if(i==0)
        {
            strPhoneNo = [Utility insertDash:item];
        }
        else
        {
            strPhoneNo = [NSString stringWithFormat:@"%@,%@",strPhoneNo,[Utility insertDash:item]];
        }
    }
    return strPhoneNo;
}

+ (NSString *)insertDash:(NSString *)text
{
    if([text length] == 10)
    {
        NSMutableString *mu = [NSMutableString stringWithString:text];
        [mu insertString:@"-" atIndex:3];
        [mu insertString:@"-" atIndex:7];
        return [NSString stringWithString:mu];
    }
    return text;
}

+ (NSData*) encryptString:(NSString*)plaintext withKey:(NSString*)key
{
    return [[plaintext dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptedDataWithKey:key];
}

+ (NSString*) decryptData:(NSData*)ciphertext withKey:(NSString*)key
{
    return [[NSString alloc] initWithData:[ciphertext AES128DecryptedDataWithKey:key]
                                 encoding:NSUTF8StringEncoding];
}

+(NSString*)addPrefixBahtSymbol:(NSString *)strAmount
{
    return [NSString stringWithFormat:@"฿ %@",strAmount];
}

+(BOOL)isExpiredDateValid:(NSDate *)date
{
    NSDate *currentDate = [self currentDateTime];
    currentDate = [Utility setStartOfTheDay:currentDate];
    NSComparisonResult result = [currentDate compare:date];
    if(result != NSOrderedAscending)
    {
        return NO;
    }
    return YES;
}

+(NSString *)hashText:(NSString *)text
{
    NSUInteger fieldHash = [text hash];
    NSString *fieldString = [KeychainWrapper securedSHA256DigestHashForPIN:fieldHash];
    
    return fieldString;
}

+(NSString *)hashTextSHA256:(NSString *)text
{
    NSString *salted = [NSString stringWithFormat:@"%@%@",text,SALT_HASH];
    NSString *fieldString = [KeychainWrapper computeSHA256DigestForString:salted];
    return fieldString;
}

+(BOOL)validateStrongPassword:(NSString *)password
{
    NSString *passwordRegex = @"(?=^.{8,}$)((?=.*\\d)|(?=.*\\W+))(?![.\\n])(?=.*[A-Z])(?=.*[a-z]).*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [predicate evaluateWithObject:password];
}

+(void)addToSharedDataList:(NSArray *)items
{
    for(int j=0; j<[items count]; j++)
    {
        NSMutableArray *dataGetList = items[j];
        for(int k=0; k<[dataGetList count]; k++)
        {
            NSObject *object = dataGetList[k];
            NSString *className = NSStringFromClass([object class]);
            NSString *strNameID = [Utility getPrimaryKeyFromClassName:className];
            
            
            Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
            SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
            NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
            
            
            if(![Utility duplicate:object])
            {
                [dataList addObject:object];
            }
        }
    }
}

+(NSString *)hideCreditCardNo:(NSString *)creditCardNo
{
    NSRange needleRange = NSMakeRange(12,4);
    NSString *last4Digit = [creditCardNo substringWithRange:needleRange];
    return [NSString stringWithFormat:@"XXXX XXXX XXXX %@",last4Digit];
}

+(void)updateSharedObject:(NSArray *)arrOfObjectList
{
    for(NSArray *itemList in arrOfObjectList)
    {
        for(NSObject *object in itemList)
        {
            [self addUpdateObject:object];
        }
    }
}

+ (void)addUpdateObject:(NSObject *)object
{
    Class classDB = [object class];
    NSString *className = NSStringFromClass(classDB);
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
    NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
    NSInteger value = [[object valueForKey:propertyName] integerValue];


    NSArray *filterArray;
    if ([object respondsToSelector:NSSelectorFromString(@"branchID")])
    {
        NSNumber *objBranchID = [object valueForKey:@"branchID"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld and branchID = %ld",propertyNamePredicate,value,[objBranchID integerValue]];
        filterArray = [dataList filteredArrayUsingPredicate:predicate];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld",propertyNamePredicate,value];
        filterArray = [dataList filteredArrayUsingPredicate:predicate];
    }
    
    
    
    if([filterArray count]==0)
    {
        [dataList addObject:object];
    }
    else
    {
        NSObject *filterObject = filterArray[0];
        NSDate *dateObject = [object valueForKey:@"modifiedDate"];
        NSDate *dateFilterObject = [filterObject valueForKey:@"modifiedDate"];
        NSComparisonResult result = [dateFilterObject compare:dateObject];
        if(result == NSOrderedAscending)
        {
            //update
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
            
            for (unsigned int i = 0; i < propertyCount; ++i)
            {
                objc_property_t property = properties[i];
                const char * name = property_getName(property);
                NSString *key = [NSString stringWithUTF8String:name];
                
                
                [filterObject setValue:[object valueForKey:key] forKey:key];
            }
        }
    }
}

+(BOOL)updateDataList:(NSArray *)itemList dataList:(NSMutableArray *)dataList
{
    BOOL update = 0;
    for(NSObject *object in itemList)
    {
        Class classDB = [object class];
        NSString *className = NSStringFromClass(classDB);
        
        
        NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
        NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
        NSInteger value = [[object valueForKey:propertyName] integerValue];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld",propertyNamePredicate,value];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        
        
        
        if([filterArray count]==0)
        {
            update = 1;
            [dataList addObject:object];
        }
        else
        {
            NSObject *filterObject = filterArray[0];
            NSDate *dateObject = [object valueForKey:@"modifiedDate"];
            NSDate *dateFilterObject = [filterObject valueForKey:@"modifiedDate"];
            NSComparisonResult result = [dateFilterObject compare:dateObject];
            if(result == NSOrderedAscending)
            {
                //update
                update = 1;
                unsigned int propertyCount = 0;
                objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
                
                for (unsigned int i = 0; i < propertyCount; ++i)
                {
                    objc_property_t property = properties[i];
                    const char * name = property_getName(property);
                    NSString *key = [NSString stringWithUTF8String:name];
                    
                    
                    [filterObject setValue:[object valueForKey:key] forKey:key];
                }
            }
        }
    }
    return update;
}

+ (void)addUpdateObject:(NSObject *)object dataList:(NSMutableArray *)dataList
{
    
}

+(void)updateItemIfModify:(NSObject *)object
{
    Class classDB = [object class];
    NSString *className = NSStringFromClass(classDB);
    Class class = NSClassFromString([NSString stringWithFormat:@"Shared%@",className]);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"shared%@",className]);
    SEL selectorList = NSSelectorFromString([NSString stringWithFormat:@"%@List",[Utility makeFirstLetterLowerCase:className]]);
    NSMutableArray *dataList = [[class performSelector:selector] performSelector:selectorList];
    
    
    NSString *propertyName = [NSString stringWithFormat:@"%@ID",[Utility makeFirstLetterLowerCase:className]];
    NSString *propertyNamePredicate = [NSString stringWithFormat:@"_%@",propertyName];
    NSInteger value = [[object valueForKey:propertyName] integerValue];
    
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %ld",propertyNamePredicate,value];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    if([filterArray count]>0)
    {
        NSObject *filterObject = filterArray[0];
        NSDate *dateObject = [object valueForKey:@"modifiedDate"];
        NSDate *dateFilterObject = [filterObject valueForKey:@"modifiedDate"];
        NSComparisonResult result = [dateFilterObject compare:dateObject];
        if(result == NSOrderedAscending)
        {
            //update
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
            
            for (unsigned int i = 0; i < propertyCount; ++i)
            {
                objc_property_t property = properties[i];
                const char * name = property_getName(property);
                NSString *key = [NSString stringWithUTF8String:name];
                
                
                [filterObject setValue:[object valueForKey:key] forKey:key];
            }
        }
    }
}

+(UIImage *)getImageFromCache:(NSString *)imageName
{
    NSRange needleRange = NSMakeRange(2,[imageName length]-2);
    NSString *saveImageName = [imageName substringWithRange:needleRange];
    saveImageName =[saveImageName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *cachedFolderPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *cachedImagePath = [cachedFolderPath stringByAppendingPathComponent:saveImageName];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:cachedImagePath]];
    
    return image;
}

+(void)saveImageInCache:(UIImage *)image imageName:(NSString *)imageName
{
    NSRange needleRange = NSMakeRange(2,[imageName length]-2);
    NSString *saveImageName = [imageName substringWithRange:needleRange];
    saveImageName =[saveImageName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *cachedFolderPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *cachedImagePath = [cachedFolderPath stringByAppendingPathComponent:saveImageName];
    [UIImagePNGRepresentation(image) writeToFile:cachedImagePath atomically:YES];
}

+(NSString *)formatPhoneNo:(NSString *)phoneNo
{
    NSString *formatPhoneNo = @"";
//    NSString *phoneNo = @"0813072993";
    for(int i=0; i<[phoneNo length]; i++)
    {
        NSRange needleRange = NSMakeRange(i,1);
        NSString *eachDigit = [phoneNo substringWithRange:needleRange];
        if(i == 3 || i == 6)
        {
            formatPhoneNo = [NSString stringWithFormat:@"%@-",formatPhoneNo];
        }
        formatPhoneNo = [NSString stringWithFormat:@"%@%@",formatPhoneNo,eachDigit];
    }
    
    return formatPhoneNo;
}
@end

