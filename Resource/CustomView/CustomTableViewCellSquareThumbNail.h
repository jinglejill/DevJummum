//
//  CustomTableViewCellSquareThumbNail.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 13/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellSquareThumbNail : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *vwLeft;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblLeft;
@property (strong, nonatomic) IBOutlet UIView *vwRight;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwRight;
@property (strong, nonatomic) IBOutlet UILabel *lblRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwLeftWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwLeftHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgVwLeftHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgVwRightHeight;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantityLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantityRight;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwTriangleLeft;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwTriangleRight;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblSpecialPriceLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceRight;
@property (strong, nonatomic) IBOutlet UILabel *lblSpecialPriceRight;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognizerLeft;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognizerRight;

@end
