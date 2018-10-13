//
//  FirstInstallAlertViewController.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 12/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"

@interface FirstInstallAlertViewController : CustomViewController
@property (strong, nonatomic) IBOutlet UIView *vwAlert;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwAlertHeight;


- (IBAction)update:(id)sender;
@end
