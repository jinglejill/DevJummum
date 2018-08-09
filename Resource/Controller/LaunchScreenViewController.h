//
//  LaunchScreenViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Setting.h"


@interface LaunchScreenViewController : CustomViewController
@property (strong, nonatomic) UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *lblAppStoreVersion;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgVwLogoTop;


-(IBAction)unwindToLaunchScreen:(UIStoryboardSegue *)segue;
@end
