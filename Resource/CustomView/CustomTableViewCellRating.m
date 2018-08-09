//
//  CustomTableViewCellRating.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 8/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomTableViewCellRating.h"

@implementation CustomTableViewCellRating

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    
    self.btnRate1.enabled = YES;
    self.btnRate2.enabled = YES;
    self.btnRate3.enabled = YES;
    self.btnRate4.enabled = YES;
    self.btnRate5.enabled = YES;
}

@end
