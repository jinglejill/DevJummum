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
@synthesize imgVwLogoTop;
@synthesize lblTitle;
@synthesize lblMessage;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    imgVwLogoTop.constant = (self.view.frame.size.height - (542-94))/2;
    
    
    vwAlert.layer.cornerRadius = 10;
    vwAlert.layer.masksToBounds = YES;
    [self setButtonDesign:btnUpdate];
    [self setButtonDesign:btnDismiss];
    [self setButtonDesign:btnCancel];
    

    NSString *strKey = [NSString stringWithFormat:@"UpdateVersion%@",appStoreVersion];
    NSString *strUpdateVersion = [Setting getSettingValueWithKeyName:strKey];
    if([strUpdateVersion integerValue])
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
    NSString *title = [Setting getValue:@"163t" example:@"It's time to update"];
    NSString *message = [Setting getValue:@"163m" example:@"A newer version of the app is available for you, please update to continue ordering your food, receiving latest promotions & benefits with JUMMUM."];
    lblHeader.text = title;
    lblSubtitle.text = message;
    
    
    
    //background
    NSString *title2 = [Setting getValue:@"002t" example:@"Welcome"];
    NSString *message2 = [Setting getValue:@"002m" example:@"Pay for your order, earn and track rewards, ckeck your balance and more, all from your mobile device"];
    lblTitle.text = title2;
    lblMessage.text = message2;
}

- (IBAction)dismiss:(id)sender
{
    NSString *key = [NSString stringWithFormat:@"dismiss verion:%@",appStoreVersion];
    [[NSUserDefaults standardUserDefaults] setValue:@1 forKey:key];
    [self performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
}

- (IBAction)update:(id)sender
{
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
}

- (IBAction)cancel:(id)sender
{
    NSLog(@"test");
    [self performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
}

- (void)openStoreProductViewControllerWithITunesItemIdentifier:(NSInteger)iTunesItemIdentifier {
    SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
    
    storeViewController.delegate = self;
    
    NSNumber *identifier = [NSNumber numberWithInteger:iTunesItemIdentifier];
    
    NSDictionary *parameters = @{ SKStoreProductParameterITunesItemIdentifier:identifier };

    [storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                       if (result)
                                           [self presentViewController:storeViewController
                                                              animated:YES
                                                            completion:nil];
                                       else NSLog(@"SKStoreProductViewController: %@", error);
                                   }];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"segUnwindToLaunchScreen" sender:self];
    }];
    
}
@end
