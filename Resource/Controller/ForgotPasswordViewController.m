//
//  ForgotPasswordViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 4/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Setting.h"


@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize lblNavTitle;
@synthesize txtEmail;
@synthesize topViewHeight;
@synthesize bottomButtonHeight;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomButtonHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtEmail)
    {
        [self submit:nil];
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *title = [Setting getValue:@"054t" example:@"ลืมรหัสผ่าน"];
    lblNavTitle.text = title;
    txtEmail.delegate = self;
    [txtEmail setInputAccessoryView:self.toolBar];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

- (IBAction)submit:(id)sender
{
    txtEmail.text = [Utility trimString:txtEmail.text];
    
    if(![Utility validateEmailWithString:txtEmail.text])
    {
        [self showAlert:@"" message:@"คุณใส่อีเมลไม่ถูกต้อง"];
        return;
    }
    
    [self loadingOverlayView];
    [self.homeModel insertItems:dbUserAccountForgotPassword withData:txtEmail.text actionScreen:@"send email for reset password"];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

-(void)itemsInsertedWithReturnData:(NSArray *)items
{
    [self removeOverlayViews];
    NSMutableArray *userAccountList = items[0];
    if([userAccountList count]==0)
    {
        [self showAlert:@"" message:@"ไม่มีอีเมลนี้ในระบบ"];
    }
    else
    {
        [self showAlert:@"" message:@"เราได้ส่งอีเมลให้คุณแล้ว กรุณาเช็คอีเมลของคุณค่ะ (ถ้าไม่พบ กรุณาตรวจสอบใน Junk mail ค่ะ)" method:@selector(goBack:)];
    }
}

@end
