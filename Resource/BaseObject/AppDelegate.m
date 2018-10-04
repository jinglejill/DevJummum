//
//  AppDelegate.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInViewController.h"
#import "ReceiptSummaryViewController.h"
#import "OrderDetailViewController.h"
#import "DisputeFormViewController.h"
#import "ConfirmDisputeViewController.h"
#import "CommentRatingViewController.h"
#import "ReceiptSummaryViewController.h"
#import "MeViewController.h"
#import "CommentViewController.h"
#import "BasketViewController.h"
#import "BranchSearchViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "CreditCardViewController.h"
#import "CustomerTableSearchViewController.h"
#import "HotDealDetailViewController.h"
#import "MenuSelectionViewController.h"
#import "MyRewardViewController.h"
#import "NoteViewController.h"
#import "PaymentCompleteViewController.h"
#import "PersonalDataViewController.h"
#import "RecommendShopViewController.h"
#import "RewardDetailViewController.h"
#import "RewardRedemptionViewController.h"
#import "SelectPaymentMethodViewController.h"
#import "TosAndPrivacyPolicyViewController.h"
#import "VoucherCodeListViewController.h"
#import "HotDealViewController.h"
#import "RewardViewController.h"
#import "QRCodeScanTableViewController.h"
#import "HotDealViewController.h"
#import "HomeModel.h"
#import "Utility.h"
#import "Receipt.h"
//#import "PushSync.h"
#import "SharedCurrentUserAccount.h"
#import <objc/runtime.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UILabel+FontAppearance.h"


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)



@interface AppDelegate (){
    HomeModel *_homeModel;
}

@end

extern BOOL globalRotateFromSeg;



@implementation AppDelegate
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)photoUploaded
{
    
}

void myExceptionHandler(NSException *exception)
{
    NSString *stackTrace = [[[exception callStackSymbols] valueForKey:@"description"] componentsJoinedByString:@"\\n"];
    stackTrace = [NSString stringWithFormat:@"%@,%@\\n%@\\n%@",[Utility modifiedUser],[Utility deviceToken],exception.reason,stackTrace];
//    NSLog(@"Stack Trace callStackSymbols: %@", stackTrace);
    
    [[NSUserDefaults standardUserDefaults] setValue:stackTrace forKey:@"exception"];
    
}

//-(void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage
//{
//    NSLog(@"remoteMessageAppData: %@",remoteMessage.appData);
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    NSString *key = [NSString stringWithFormat:@"dismiss verion:(null)"];
//    [[NSUserDefaults standardUserDefaults] setValue:@0 forKey:key];
    
    UIBarButtonItem *barButtonAppearance = [UIBarButtonItem appearance];
    [barButtonAppearance setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault]; // Change to your colour
    
    
    _homeModel = [[HomeModel alloc]init];
    _homeModel.delegate = self;
    
    
    globalRotateFromSeg = NO;
    
    // Override point for customization after application launch.
    NSString *strplistPath = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    
    // read property list into memory as an NSData  object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:strplistPath];
    NSError *strerrorDesc = nil;
    NSPropertyListFormat plistFormat;
    
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&plistFormat error:&strerrorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %lu", strerrorDesc, (unsigned long)plistFormat);
    }
    else
    {
        // assign values        
        [Utility setPingAddress:[temp objectForKey:@"PingAddress"]];
        [Utility setDomainName:[temp objectForKey:@"DomainName"]];
        [Utility setSubjectNoConnection:[temp objectForKey:@"SubjectNoConnection"]];
        [Utility setDetailNoConnection:[temp objectForKey:@"DetailNoConnection"]];
        [Utility setDetailNoConnection:[temp objectForKey:@"DetailNoConnection"]];
        [Utility setKey:[temp objectForKey:@"Key"]];
        [Utility setBundleID:[temp objectForKey:@"BundleID"]];        
    }
    
    

    //write exception of latest app crash to log file
    NSSetUncaughtExceptionHandler(&myExceptionHandler);
    NSString *stackTrace = [[NSUserDefaults standardUserDefaults] stringForKey:@"exception"];
    if(!stackTrace)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"exception"];
    }
    else if(![stackTrace isEqualToString:@""])
    {
        [_homeModel insertItems:dbWriteLog withData:stackTrace actionScreen:@"Logging"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"exception"];
    }
    

    //push notification
    {
//        [FIRApp configure];
        if ([UNUserNotificationCenter class] != nil)//version >= 10
        {
            
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
             {
                 if( !error )
                 {
                     NSLog( @"Push registration success." );
                 }
                 else
                 {
                     NSLog( @"Push registration FAILED" );
                     NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                     NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
                 }
             }];
        }
        else
        {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [application registerUserNotificationSettings:settings];
        }
        [application registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
//        [FIRMessaging messaging].delegate = self;
    }
    
    
    
    #if (TARGET_OS_SIMULATOR)
        NSString *token = @"simulator";
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN];
    #endif


    //facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    return YES;
}

#ifdef __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options {

    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];

    return YES;
}
#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

    return YES;
}
#endif


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    
    //Called when a notification is delivered to a foreground app.
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"notification is delivered to a foreground app: %@", userInfo);
    
    //////////////////
    
    //reload when in receipt summary and orderDetail vc
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    if([currentVc isKindOfClass:[ReceiptSummaryViewController class]])
    {
    }
    else if([currentVc isKindOfClass:[OrderDetailViewController class]])
    {
    }
    else
    {
        completionHandler(UNNotificationPresentationOptionAlert);
    }
    //////////////////
    
    NSDictionary *myAps = [userInfo objectForKey:@"aps"];
    NSString *categoryIdentifier = [myAps objectForKey:@"category"];
    if([categoryIdentifier isEqualToString:@"updateStatus"])
    {
        NSDictionary *data = [myAps objectForKey:@"data"];
        NSNumber *receiptID = [data objectForKey:@"receiptID"];
        
        
        Receipt *receipt = [Receipt getReceipt:[receiptID integerValue]];
        if(receipt)
        {
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbReceiptDisputeRatingUpdateAndReload withData:receipt];
        }
        else
        {
            Receipt *receipt = [[Receipt alloc]init];
            receipt.receiptID = [receiptID integerValue];
            
            
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbReceiptDisputeRatingAllAfterReceiptUpdateAndReload withData:receipt];
        }
    }
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSDictionary *myAps = [userInfo objectForKey:@"aps"];
    NSString *categoryIdentifier = [myAps objectForKey:@"category"];
    NSLog(@"action was selected by the user for a given notification: %@", userInfo);
    
    
    if([categoryIdentifier isEqualToString:@"updateStatus"])
    {
        NSDictionary *data = [myAps objectForKey:@"data"];
        NSNumber *receiptID = [data objectForKey:@"receiptID"];
        
        
        Receipt *receipt = [Receipt getReceipt:[receiptID integerValue]];
        if(receipt)
        {
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbReceiptDisputeRating withData:receipt];
        }
        else
        {
            Receipt *receipt = [[Receipt alloc]init];
            receipt.receiptID = [receiptID integerValue];
            
            
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbReceiptDisputeRatingAllAfterReceipt withData:receipt];
        }
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token---%@", token);

    
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
//    NSLog(@"FCM registration token: %@", fcmToken);
//    // Notify about received token.
//    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:
//     @"FCMToken" object:nil userInfo:dataDict];
//    // TODO: If necessary send token to application server.
//    // Note: This callback is fired at each app startup and whenever a new token is generated.
//}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //    NSLog([error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"didReceiveRemoteNotification: %@", userInfo);
    
    
    NSDictionary *myAps = [userInfo objectForKey:@"aps"];
    NSString *categoryIdentifier = [myAps objectForKey:@"category"];
    if([categoryIdentifier isEqualToString:@"updateStatus"])
    {
        NSDictionary *data = [myAps objectForKey:@"data"];
        NSNumber *receiptID = [data objectForKey:@"receiptID"];
        
        
        Receipt *receipt = [Receipt getReceipt:[receiptID integerValue]];
        if(receipt)
        {
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbReceiptDisputeRatingUpdateAndReload withData:receipt];
        }
        else
        {
            Receipt *receipt = [[Receipt alloc]init];
            receipt.receiptID = [receiptID integerValue];
            
            
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbReceiptDisputeRatingAllAfterReceiptUpdateAndReload withData:receipt];
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    
    //    if (application.applicationState == UIApplicationStateBackground)
    
    //    if(application.applicationState == UIApplicationStateInactive)
    //    {
    //
    //        NSLog(@"Inactive");
    //
    //        //Show the view with the content of the push
    //
    //        completionHandler(UIBackgroundFetchResultNewData);
    //
    //    }
    //    else if (application.applicationState == UIApplicationStateBackground)
    //    {
    //
    //        NSLog(@"Background");
    //
    //        //Refresh the local model
    //
    //        completionHandler(UIBackgroundFetchResultNewData);
    //    }
    //    else
    //    {
    //
    //        NSLog(@"Active");
    //
    //        //Show an in-app banner
    //
    //        completionHandler(UIBackgroundFetchResultNewData);
    //    }
}

- (void)itemsUpdated
{
    
}

- (void)itemsInserted
{
    
}

- (void)itemsDeleted
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    //reload when in receipt summary and orderDetail vc
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    
    if([currentVc isKindOfClass:[ReceiptSummaryViewController class]])
    {
        ReceiptSummaryViewController *vc = (ReceiptSummaryViewController *)currentVc;
        [vc reloadTableView];
    }
    else if([currentVc isKindOfClass:[OrderDetailViewController class]])
    {
        OrderDetailViewController *vc = (OrderDetailViewController *)currentVc;
        [vc reloadTableView];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbReceiptDisputeRating || homeModel.propCurrentDB == dbReceiptDisputeRatingAllAfterReceipt)//tap at noti
    {
        //update
        NSLog(@"before updateSharedObject ");
        
        [Utility updateSharedObject:items];
        NSLog(@"after updateSharedObject");
        
        
        //ไม่ว่าอยู่หน้าไหน ให้ไปที่หน้า orderDetail
        //หาก unwind ให้ scroll ไปที่ receipt ใบนั้น
        //reload when in receipt summary and orderDetail vc
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        
        NSMutableArray *receiptList = items[0];
        Receipt *receipt = receiptList[0];
        Receipt *selectedReceipt = [Receipt getReceipt:receipt.receiptID];
        if([currentVc isKindOfClass:[OrderDetailViewController class]])
        {
            OrderDetailViewController *vc = (OrderDetailViewController *)currentVc;
            vc.receipt = selectedReceipt;
            [vc reloadTableView];
        }
        else if([currentVc isKindOfClass:[ConfirmDisputeViewController class]] || [currentVc isKindOfClass:[DisputeFormViewController class]] || [currentVc isKindOfClass:[CommentRatingViewController class]])
        {
            currentVc.selectedReceipt = selectedReceipt;
            currentVc.showOrderDetail = 1;
            [currentVc performSegueWithIdentifier:@"segUnwindToOrderDetail" sender:self];
        }
        else if([currentVc isKindOfClass:[ReceiptSummaryViewController class]])
        {
            ReceiptSummaryViewController *vc = (ReceiptSummaryViewController *)currentVc;
            [vc segueToOrderDetailAuto:selectedReceipt];
        }
        else if([currentVc isKindOfClass:[CommentViewController class]] ||
                [currentVc isKindOfClass:[BasketViewController class]] ||
                [currentVc isKindOfClass:[BranchSearchViewController class]] ||
                [currentVc isKindOfClass:[CreditCardAndOrderSummaryViewController class]] ||
                [currentVc isKindOfClass:[CreditCardViewController class]] ||
                [currentVc isKindOfClass:[CustomerTableSearchViewController class]] ||
                [currentVc isKindOfClass:[HotDealDetailViewController class]] ||
                [currentVc isKindOfClass:[MenuSelectionViewController class]] ||
                [currentVc isKindOfClass:[MyRewardViewController class]] ||
                [currentVc isKindOfClass:[NoteViewController class]] ||
                [currentVc isKindOfClass:[PaymentCompleteViewController class]] ||
                [currentVc isKindOfClass:[PersonalDataViewController class]] ||
                [currentVc isKindOfClass:[RecommendShopViewController class]] ||
                [currentVc isKindOfClass:[RewardDetailViewController class]] ||
                [currentVc isKindOfClass:[RewardRedemptionViewController class]] ||
                [currentVc isKindOfClass:[SelectPaymentMethodViewController class]] ||
                [currentVc isKindOfClass:[TosAndPrivacyPolicyViewController class]] ||
                [currentVc isKindOfClass:[VoucherCodeListViewController class]])
        {
            currentVc.selectedReceipt = selectedReceipt;
            currentVc.showOrderDetail = 1;
            [currentVc performSegueWithIdentifier:@"segUnwindToMainTabBar" sender:self];
        }
        else if([currentVc isKindOfClass:[HotDealViewController class]] || [currentVc isKindOfClass:[RewardViewController class]] || [currentVc isKindOfClass:[QRCodeScanTableViewController class]] || [currentVc isKindOfClass:[MeViewController class]])
        {
            currentVc.tabBarController.selectedIndex = mainTabHistory;//receiptSummary
            ReceiptSummaryViewController *vc = currentVc.tabBarController.selectedViewController;
            vc.showOrderDetail = 1;
            vc.selectedReceipt = selectedReceipt;
            [vc viewDidAppear:NO];
        }
    }
    else if(homeModel.propCurrentDB == dbReceiptDisputeRatingUpdateAndReload || homeModel.propCurrentDB == dbReceiptDisputeRatingAllAfterReceiptUpdateAndReload)
    {
        //update
        [Utility updateSharedObject:items];
        
        
        
        //reload when in receipt summary and orderDetail vc
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[ReceiptSummaryViewController class]])
        {
            ReceiptSummaryViewController *vc = (ReceiptSummaryViewController *)currentVc;
            [vc reloadTableView];
        }
        else if([currentVc isKindOfClass:[OrderDetailViewController class]])
        {
            OrderDetailViewController *vc = (OrderDetailViewController *)currentVc;
            [vc reloadTableView];
        }
    }
}

- (void) connectionFail
{
    //เอา font มาใส่
    NSString *title = [Utility subjectNoConnection];
    NSString *message = [Utility detailNoConnection];
    
    
    
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    
    //present alertController
    [currentVc removeOverlayViews];
    [currentVc showAlert:title message:message];
}


- (void)itemsFail
{
    NSString *title = [Utility getErrorOccurTitle];
    NSString *message = [Utility getErrorOccurMessage];
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    
    //present alertController
    [currentVc removeOverlayViews];
    [currentVc showAlert:title message:message];
}


@end
