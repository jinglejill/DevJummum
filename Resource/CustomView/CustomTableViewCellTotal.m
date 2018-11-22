//
//  CustomTableViewCellTotal.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 25/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomTableViewCellTotal.h"
#import "Utility.h"


@implementation CustomTableViewCellTotal

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
    self.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
    self.lblAmount.textColor = cSystem1;
    self.lblAmountWidth.constant = 150;
    self.vwTopBorder.hidden = YES;
    self.vwBottomBorder.hidden = YES;
}
@end
