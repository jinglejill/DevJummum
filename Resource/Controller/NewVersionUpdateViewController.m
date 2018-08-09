//
//  NewVersionUpdateViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 2/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "NewVersionUpdateViewController.h"
#import "Setting.h"


@interface NewVersionUpdateViewController ()

@end

@implementation NewVersionUpdateViewController
@synthesize lblHeader;
@synthesize lblSubtitle;
@synthesize vwAlert;
@synthesize btnUpdate;
@synthesize btnDismiss;
@synthesize btnDismissTop;
@synthesize btnDismissHeight;
@synthesize btnCancel;
@synthesize btnCancelTop;
@synthesize btnCancelHeight;
@synthesize appStoreVersion;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    vwAlert.layer.cornerRadius = 10;
    vwAlert.layer.masksToBounds = YES;
    [self setButtonDesign:btnUpdate];
    [self setButtonDesign:btnDismiss];
    [self setButtonDesign:btnCancel];
    
    
    NSString *strVersionType = [Setting getSettingValueWithKeyName:@"NewVersionType"];
    if([strVersionType integerValue] == 1)
    {
        
    }
    else
    {
        btnDismissTop.constant = 0;
        btnDismissHeight.constant = 0;
        btnDismiss.hidden = YES;
        btnCancelTop.constant = 0;
        btnCancelHeight.constant = 0;
        btnCancel.hidden = YES;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lblHeader.text = [Setting getSettingValueWithKeyName:@"NewVersionTitle"];
    lblSubtitle.text = [Setting getSettingValueWithKeyName:@"NewVersionMessage"];
}

- (IBAction)dismiss:(id)sender
{
    NSString *key = [NSString stringWithFormat:@"dismiss verion:%@",appStoreVersion];
    [[NSUserDefaults standardUserDefaults] setValue:@1 forKey:key];
    [self performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
}

- (IBAction)update:(id)sender
{
    //go to app store
    //    static NSInteger const kAppITunesItemIdentifier = 1404154271;//324684580;
    //    [self openStoreProductViewControllerWithITunesItemIdentifier:kAppITunesItemIdentifier];
    
    
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if([lookup[@"results"] count] > 0)
    {
        NSString * appITunesItemIdentifier =  lookup[@"results"][0][@"trackId"];
        [self openStoreProductViewControllerWithITunesItemIdentifier:[appITunesItemIdentifier intValue]];
    }
    else
    {
        [self alertMsg:@"Cannot update"];
    }
    //
    
    
//    NSString *iTunesLink = @"https://itunes.apple.com/th/app/the-1-card/id442873215?mt=8";
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    
    //    NSString *iTunesLink = @"itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8";
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

- (IBAction)cancel:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
}



- (void)openStoreProductViewControllerWithITunesItemIdentifier:(NSInteger)iTunesItemIdentifier {
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    
    storeViewController.delegate = self;
    
    NSNumber *identifier = [NSNumber numberWithInteger:iTunesItemIdentifier];
    
    NSDictionary *parameters = @{ SKStoreProductParameterITunesItemIdentifier:identifier };
    //    UIViewController *viewController = self.window.rootViewController;
    [storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                       if (result)
                                           [self presentViewController:storeViewController
                                                              animated:YES
                                                            completion:nil];
                                       else NSLog(@"SKStoreProductViewController: %@", error);
                                   }];
    
    //    [storeViewController release];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
//    [viewController dismissViewControllerAnimated:YES completion:nil];
    [viewController dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
    }];
    
}
@end
