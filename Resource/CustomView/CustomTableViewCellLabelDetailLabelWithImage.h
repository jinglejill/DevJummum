//
//  CustomTableViewCellLabelDetailLabelWithImage.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 15/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellLabelDetailLabelWithImage : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblValueWidth;

@end
