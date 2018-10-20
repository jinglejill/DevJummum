//
//  MessageBoxWithDismissViewController.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 12/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"

@interface MessageBoxWithDismissViewController : CustomViewController

@property (strong, nonatomic) IBOutlet UIView *vwAlert;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwAlertHeight;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnDontShowItAgain;
@property (strong, nonatomic) IBOutlet UIButton *btnOK;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblMessageHeight;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;


- (IBAction)dontShowItAgain:(id)sender;
- (IBAction)okClicked:(id)sender;

@end
