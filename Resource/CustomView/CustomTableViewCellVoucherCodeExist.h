//
//  CustomTableViewCellVoucherCodeExist.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 29/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellVoucherCodeExist : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnChooseVoucherCode;
@property (strong, nonatomic) IBOutlet UITextField *txtVoucherCode;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnConfirmWidth;

@end
