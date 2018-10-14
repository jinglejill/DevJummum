//
//  CustomTableViewCellSquareThumbNail.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 13/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomTableViewCellSquareThumbNail.h"

@implementation CustomTableViewCellSquareThumbNail
@synthesize singleTapGestureRecognizerLeft;
@synthesize singleTapGestureRecognizerRight;


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self)
    {
        singleTapGestureRecognizerLeft = [[UITapGestureRecognizer alloc]init];
        singleTapGestureRecognizerRight = [[UITapGestureRecognizer alloc]init];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
