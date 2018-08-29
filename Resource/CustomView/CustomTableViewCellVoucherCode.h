//
//  CustomTableViewCellVoucherCode.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 18/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTableViewCellVoucherCode : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *txtVoucherCode;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirmVoucherCode;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnConfirmVoucherCodeWidthConstant;

@end
