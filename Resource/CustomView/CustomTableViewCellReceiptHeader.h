//
//  CustomTableViewCellReceiptHeader.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 28/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellReceiptHeader : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptNo;
@property (strong, nonatomic) IBOutlet UILabel *lblBranchName;
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptDate;

@end
