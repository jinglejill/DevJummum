//
//  LogInViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 17/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LogInViewController : CustomViewController<FBSDKLoginButtonDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgVwLogoText;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnRememberMe;
@property (strong, nonatomic) IBOutlet UIButton *btnLogIn;
@property (strong, nonatomic) IBOutlet UIButton *btnRegisterNow;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgVwValueHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblLogInTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnRememberMeWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblOrBottom;
@property (strong, nonatomic) IBOutlet UILabel *lblPipe;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblPipeLeading;
@property (strong, nonatomic) IBOutlet UIButton *btnLangEn;
@property (strong, nonatomic) IBOutlet UIButton *btnLangTH;
- (IBAction)switchToEN:(id)sender;
- (IBAction)switchToTH:(id)sender;
- (IBAction)rememberMe:(id)sender;
- (IBAction)logIn:(id)sender;
- (IBAction)registerNow:(id)sender;
- (IBAction)forgotPassword:(id)sender;


-(IBAction)unwindToLogIn:(UIStoryboardSegue *)segue;
@end
