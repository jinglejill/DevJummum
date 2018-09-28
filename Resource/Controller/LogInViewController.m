//
//  LogInViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 17/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "LogInViewController.h"
#import "TermsOfServiceViewController.h"
#import "RegisterNowViewController.h"
#import "MeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


#import "LogIn.h"
#import "UserAccount.h"
#import "Utility.h"
#import "FacebookComment.h"



@interface LogInViewController ()
{
    FBSDKLoginButton *_loginButton;
    BOOL _faceBookLogIn;
    BOOL _appLogIn;
    BOOL _rememberMe;
    NSString *_username;
    NSMutableArray *allComments;
    BOOL _autoLogIn;
    UserAccount *_userAccount;
}
@end

@implementation LogInViewController
@synthesize txtEmail;
@synthesize txtPassword;
@synthesize btnRememberMe;
@synthesize btnRememberMeWidth;
@synthesize btnRegisterNow;
@synthesize btnForgotPassword;
@synthesize btnLogIn;
@synthesize imgVwValueHeight;
@synthesize lblOrBottom;
@synthesize imgVwLogoText;
@synthesize lblLogInTop;
@synthesize lblPipeLeading;
@synthesize btnLangEn;
@synthesize btnLangTH;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    imgVwValueHeight.constant = self.view.frame.size.width/375*255;
    float bottom = imgVwValueHeight.constant+20+30+11;
    lblOrBottom.constant = bottom;
    
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    float bottomPadding = window.safeAreaInsets.bottom;
//    float topPadding = window.safeAreaInsets.top;
    _loginButton.center = self.view.center;
    CGRect frame = _loginButton.frame;
    frame.origin.y = self.view.frame.size.height - bottomPadding - bottom + 11;
    _loginButton.frame = frame;
    
    
    
    lblLogInTop.constant = 7 + bottomPadding;
    if(bottom+286+40>self.view.frame.size.height)
    {
        //hide jummum text
        imgVwLogoText.hidden = YES;
    }
    
    

    if(_rememberMe)
    {
        [btnRememberMe setTitle:[Language getText:@"◼︎ จำฉันไว้ในระบบ"] forState:UIControlStateNormal];
    }
    else
    {
        [btnRememberMe setTitle:[Language getText:@"◻︎ จำฉันไว้ในระบบ"] forState:UIControlStateNormal];
    }
    [btnRememberMe sizeToFit];
    btnRememberMeWidth.constant = btnRememberMe.frame.size.width;
    
    
    
    [btnRegisterNow setTitle:[Language getText:@"ลงทะเบียน"] forState:UIControlStateNormal];
    [btnRegisterNow sizeToFit];
    
    
    
    [btnForgotPassword setTitle:[Language getText:@"ลืมรหัสผ่าน"] forState:UIControlStateNormal];
    [btnForgotPassword sizeToFit];
    
    
    
    lblPipeLeading.constant = (btnForgotPassword.frame.origin.x - (btnRegisterNow.frame.origin.x + btnRegisterNow.frame.size.width))/2;
    
    
}

- (IBAction)rememberMe:(id)sender
{
    
    if(!_rememberMe)
    {
        [btnRememberMe setTitle:@"◼︎ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
    }
    else
    {
        [btnRememberMe setTitle:@"◻︎ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
    }
    _rememberMe = !_rememberMe;
}

- (IBAction)logIn:(id)sender
{
    if(!sender)
    {
        _autoLogIn = YES;
    }
    if([Utility isStringEmpty:txtEmail.text] && [Utility isStringEmpty:txtPassword.text])
    {
        [self showAlert:@"" message:@"กรุณาใส่อีเมลและพาสเวิร์ด"];
        return;
    }
    txtEmail.text = [Utility trimString:txtEmail.text];
    txtPassword.text = [Utility trimString:txtPassword.text];
    [Utility setModifiedUser:txtEmail.text];
    
    
    UserAccount *userAccount = [[UserAccount alloc]init];
    userAccount.username = txtEmail.text;
    userAccount.password = [Utility hashTextSHA256:txtPassword.text];
    
    
    LogIn *logIn = [[LogIn alloc]initWithUsername:userAccount.username status:1 deviceToken:[Utility deviceToken] model:[self deviceName]];
    [self.homeModel insertItems:dbUserAccountValidate withData:@[userAccount,logIn] actionScreen:@"validate userAccount"];
    [self loadingOverlayView];
    
}


- (IBAction)registerNow:(id)sender
{
    [self performSegueWithIdentifier:@"segRegisterNow" sender:self];
}

- (IBAction)forgotPassword:(id)sender
{
    [self performSegueWithIdentifier:@"segForgotPassword" sender:self];
}

-(IBAction)unwindToLogIn:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isMemberOfClass:[TermsOfServiceViewController class]])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"logInSession"];
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    else if([segue.sourceViewController isMemberOfClass:[RegisterNowViewController class]])
    {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        _faceBookLogIn = NO;
    }
    else if([segue.sourceViewController isMemberOfClass:[MeViewController class]])
    {
        [btnRememberMe setTitle:@"◻︎ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
        _rememberMe = NO;
        
        
        txtEmail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberEmail"];
        txtPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberPassword"];
    }
    
    if (![FBSDKAccessToken currentAccessToken])
    {
        _faceBookLogIn = NO;
    }
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"logInSession"])
    {
        _appLogIn = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setButtonDesign:btnLogIn];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"rememberMe"])
    {
        [btnRememberMe setTitle:@"◼︎ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
        _rememberMe = YES;
        
        
        txtEmail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberEmail"];
        txtPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberPassword"];
        
    }
    else
    {
        [btnRememberMe setTitle:@"◻︎ จำฉันไว้ในระบบ" forState:UIControlStateNormal];
        _rememberMe = NO;
    }
    
    
    
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    //facebook
    _loginButton = [[FBSDKLoginButton alloc] init];
    _loginButton.delegate = self;
    _loginButton.readPermissions = @[@"public_profile", @"email"];
    //    _loginButton.readPermissions = @[@"public_profile", @"email",@"user_friends",@"user_birthday",@"user_about_me",@"user_likes",@"user_work_history"];
    
    
    
    // Optional: Place the button in the center of your view.
    [self.view addSubview:_loginButton];
    if ([FBSDKAccessToken currentAccessToken])
    {
        // User is logged in, do work such as go to next view controller.
        _faceBookLogIn = YES;
    }
    else if([[NSUserDefaults standardUserDefaults] integerForKey:@"logInSession"])
    {
        _appLogIn = YES;
    }
    
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if(!error)
    {
        if ([FBSDKAccessToken currentAccessToken])
        {
            _faceBookLogIn = YES;
        }
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_faceBookLogIn)
    {
        // User is logged in, do work such as go to next view controller.
        [self insertUserLoginAndUserAccount];
    }
    else if(_appLogIn)
    {
        [self logIn:nil];
    }
    
    [self setLanguageButton];
}

-(void)setLanguageButton
{
    if([[Language getLanguage] isEqualToString:@"TH"])
    {
        [btnLangTH setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLangEn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btnLangTH.titleLabel.font = [UIFont fontWithName:@"Prompt-SemiBold" size:14];
        btnLangEn.titleLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:14];
    }
    else
    {
        [btnLangTH setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnLangEn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        btnLangTH.titleLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:14];
        btnLangEn.titleLabel.font = [UIFont fontWithName:@"Prompt-SemiBold" size:14];
    }
}

- (IBAction)switchToEN:(id)sender
{
    [Language setLanguage:@"EN"];
    [self setLanguageButton];
    [self viewDidLayoutSubviews];
}

- (IBAction)switchToTH:(id)sender
{
    [Language setLanguage:@"TH"];
    [self setLanguageButton];
    [self viewDidLayoutSubviews];
}

//facebook
-(void)insertUserLoginAndUserAccount
{
    NSLog(@"insert user log in");
    //    if(_faceBookLogIn)
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"location,email,name,first_name,last_name,gender,age_range,birthday,friends,likes"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 
                 NSLog(@"fetched user:%@", result);
                 NSLog(@"birthday:%@",result[@"birthday"]);
                 NSDate *birthday = [Utility stringToDate:result[@"birthday"] fromFormat:@"dd/MM/yyyy"];
                 
                 //1.insert userlogin
                 //2.insert useraccount if not exist
                 NSString *modifiedUser = [NSString stringWithFormat:@"%@",result[@"email"]];
                 [Utility setModifiedUser:modifiedUser];
                 LogIn *logIn = [[LogIn alloc]initWithUsername:result[@"id"] status:1 deviceToken:[Utility deviceToken] model:[self deviceName]];
                 UserAccount *userAccount = [[UserAccount alloc]initWithUsername:result[@"id"] password:txtPassword.text deviceToken:[Utility deviceToken] firstName:result[@"first_name"] lastName:result[@"last_name"] fullName:result[@"name"] nickName:@"" birthDate:birthday email:result[@"email"] phoneNo:@"" lineID:@"" roleID:0];
                 [self.homeModel insertItems:dbLogInUserAccount withData:@[logIn,userAccount] actionScreen:@"insert login and useraccount if not exist in logIn screen"];
                 [self loadingOverlayView];
             }
             else
             {
                 [self showAlert:@"" message:@"There is problem with facebook login, please try again"];
                 NSLog(@"test error: %@",error.description);
             }
         }];
    }
}

//app logIn
-(void)itemsInsertedWithReturnData:(NSArray *)items;
{
    [self removeOverlayViews];
    if(self.homeModel.propCurrentDBInsert == dbUserAccountValidate)//jummum login
    {
        if([items count] > 0 && [items[0] count] == 0)
        {
            [self showAlert:@"" message:@"อีเมล/พาสเวิร์ด ไม่ถูกต้อง"];
        }
        else
        {
            //insert useraccount,receipt,ordertaking,ordernote,menu to sharedObject
            NSMutableArray *userAccountList = items[0];
            [UserAccount setCurrentUserAccount:userAccountList[0]];
            [Utility updateSharedObject:items];
            
            
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"logInSession"];
            [[NSUserDefaults standardUserDefaults] setInteger:_rememberMe forKey:@"rememberMe"];
            if(_rememberMe)
            {
                [[NSUserDefaults standardUserDefaults] setValue:txtEmail.text forKey:@"rememberEmail"];
                [[NSUserDefaults standardUserDefaults] setValue:txtPassword.text forKey:@"rememberPassword"];
            }
            
            
            
            //show terms of service
            NSDictionary *dicTosAgree = [[NSUserDefaults standardUserDefaults] valueForKey:@"tosAgree"];
            if(dicTosAgree)
            {
                NSString *username;
                {
                    username = txtEmail.text;
                    NSNumber *tosAgree = [dicTosAgree objectForKey:username];
                    if(!tosAgree)
                    {
                        [self performSegueWithIdentifier:@"segTermsOfService" sender:self];
                    }
                    else
                    {
                        //                        if(_autoLogIn)
                        {
                            //
                            [UIView setAnimationsEnabled:NO];
                            self.view.hidden = YES;
                            [self performSegueWithIdentifier:@"segQrCodeScanTable" sender:self];
                            
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [UIView setAnimationsEnabled:YES];
                                self.view.hidden = NO;
                            });
                        }
                    }
                }
            }
            else
            {
                [self performSegueWithIdentifier:@"segTermsOfService" sender:self];
            }
        }
    }
    else if(self.homeModel.propCurrentDBInsert == dbLogInUserAccount)//facebook
    {
        //insert useraccount,receipt,ordertaking,ordernote,menu to sharedObject
        NSMutableArray *userAccountList = items[0];
        UserAccount *userAccount = userAccountList[0];
        _userAccount = userAccount;
        [UserAccount setCurrentUserAccount:userAccount];
        [Utility updateSharedObject:items];
        
        NSString *fbUsername = [NSString stringWithFormat:@"FB_%@",userAccount.username];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if(![userDefaults boolForKey:fbUsername])
        {
            [userDefaults setBool:YES forKey:fbUsername];
            [self performSegueWithIdentifier:@"segRegisterNowFacebook" sender:self];
            return;
        }
        //        if([Utility isStringEmpty:userAccount.phoneNo] || !userAccount.birthDate)
        //        {
        //            //go to register page
        //            [self performSegueWithIdentifier:@"segRegisterNowFacebook" sender:self];
        //            return;
        //        }
        
        
        //show terms of service
        NSDictionary *dicTosAgree = [[NSUserDefaults standardUserDefaults] valueForKey:@"tosAgree"];
        NSString *username = _userAccount.username;
        NSNumber *tosAgree = [dicTosAgree objectForKey:username];
        if(tosAgree)
        {
            [self performSegueWithIdentifier:@"segQrCodeScanTable" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"segTermsOfService" sender:self];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segTermsOfService"])
    {
        TermsOfServiceViewController *vc = segue.destinationViewController;
        if(_faceBookLogIn)
        {
            vc.username = [[FBSDKAccessToken currentAccessToken] userID];
        }
        else
        {
            vc.username = txtEmail.text;
        }
    }
    else if([[segue identifier] isEqualToString:@"segRegisterNowFacebook"])
    {
        RegisterNowViewController *vc = segue.destinationViewController;
        vc.userAccount = _userAccount;
    }
}

@end

