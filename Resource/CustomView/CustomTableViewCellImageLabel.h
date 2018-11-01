//
//  CustomTableViewCellImageLabel.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 23/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellImageLabel : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgValue;
@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UILabel *lblBranchName;

@end
