//
//  MessageBoxWithDismissViewController.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 12/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "MessageBoxWithDismissViewController.h"

@interface MessageBoxWithDismissViewController ()
{
    BOOL _dontShowItAgain;
    NSInteger _countAnim;
}
@end

@implementation MessageBoxWithDismissViewController
@synthesize lblMessage;
@synthesize vwAlertHeight;
@synthesize lblMessageHeight;
@synthesize vwAlert;
@synthesize btnOK;
@synthesize btnDontShowItAgain;
@synthesize imgArrow;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    lblMessage.text = [Language getText:@"- กรุณากดเลือกโต๊ะเพื่อสแกน QR Code เลขโต๊ะ\n- คุณสามารถแก้ไขรายการอาหารได้โดยกดที่ปุ่ม +/-ด้านบนขวามือ"];
    [lblMessage sizeToFit];
    lblMessageHeight.constant = lblMessage.frame.size.height;
    vwAlertHeight.constant = 30+lblMessageHeight.constant+30+btnDontShowItAgain.frame.size.height+16+btnOK.frame.size.height+8;
    [self setButtonDesign:btnOK];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [btnDontShowItAgain setTitle:@"◻︎ Don't show it again" forState:UIControlStateNormal];
    _dontShowItAgain = NO;
    

    vwAlert.layer.cornerRadius = 10;
    vwAlert.layer.masksToBounds = YES;
    
    [self startAnim];
//    [self blinkForever:imgArrow];
//    imgArrow.animationImages = @[[UIImage imageNamed:@"twirlArrow.png"],[UIImage imageNamed:@"twirlArrowBlank.png"]];
//    imgArrow.animationDuration = 1;
//    imgArrow.animationRepeatCount = INFINITY;
}



- (void)startAnim
{
    NSInteger maxBlind = 4;

    CGFloat animDuration = 0.5f;
    [UIView animateWithDuration:animDuration
                     animations:^{
                         imgArrow.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:animDuration
                                          animations:^{
                                              imgArrow.alpha = 1.f;
                                          } completion:^(BOOL finished) {
                                              if (_countAnim < maxBlind){
                                                  [self startAnim];
                                                  _countAnim++;
                                              }
                                          }];
                     }];
}

-(void)blinkForever:(UIView*)view
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{

        view.alpha = 0.0;

    } completion:nil];
}

- (IBAction)okClicked:(id)sender
{
    if(_dontShowItAgain)
    {
        UserAccount *userAccount = [UserAccount getCurrentUserAccount];
        NSMutableDictionary *dontShowMessageMenuUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"MessageMenuUpdate"];
        if(!dontShowMessageMenuUpdate)
        {
            dontShowMessageMenuUpdate = [[NSMutableDictionary alloc]init];
        }
        
        [dontShowMessageMenuUpdate setValue:@"1" forKey:userAccount.username];
        [[NSUserDefaults standardUserDefaults] setObject:dontShowMessageMenuUpdate forKey:@"MessageMenuUpdate"];
    }
    
    
    
//    [[NSUserDefaults standardUserDefaults] setBool:_dontShowItAgain forKey:@"MessageMenuUpdate"];
    [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
}

- (IBAction)dontShowItAgain:(id)sender
{
    _dontShowItAgain = !_dontShowItAgain;
    if(_dontShowItAgain)
    {
        [btnDontShowItAgain setTitle:@"◼︎ Don't show it again" forState:UIControlStateNormal];
    }
    else
    {
        [btnDontShowItAgain setTitle:@"◻︎ Don't show it again" forState:UIControlStateNormal];
    }
}
@end
