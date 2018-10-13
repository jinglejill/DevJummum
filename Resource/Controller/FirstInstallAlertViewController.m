//
//  FirstInstallAlertViewController.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 12/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "FirstInstallAlertViewController.h"

@interface FirstInstallAlertViewController ()

@end

@implementation FirstInstallAlertViewController
@synthesize lblHeader;
@synthesize lblSubtitle;
@synthesize vwAlert;
@synthesize btnUpdate;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    vwAlert.layer.cornerRadius = 10;
    vwAlert.layer.masksToBounds = YES;
    [self setButtonDesign:btnUpdate];
    
    
    [btnUpdate setTitle:[Language getText:@"เริ่มต้นใช้งาน"] forState:UIControlStateNormal];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title = [Language getText:@"ยินดีต้อนรับ"];
    NSString *message = [Language getText:@"คุณสามารถ log in ผ่าน facebook หรือกดลงทะเบียนเพื่อสมัครใช้งานค่ะ"];
    lblHeader.text = title;
    lblSubtitle.text = message;
    
}

- (IBAction)update:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

@end
