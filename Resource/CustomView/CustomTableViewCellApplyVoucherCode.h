//
//  CustomTableViewCellApplyVoucherCode.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 21/11/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellApplyVoucherCode : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblVoucherCode;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscountAmount;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblVoucherCodeWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblDiscountAmountWidth;
@end
