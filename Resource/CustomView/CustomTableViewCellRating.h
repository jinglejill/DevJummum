//
//  CustomTableViewCellRating.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 8/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellRating : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblRate;
@property (strong, nonatomic) IBOutlet UIButton *btnRate1;
@property (strong, nonatomic) IBOutlet UIButton *btnRate2;
@property (strong, nonatomic) IBOutlet UIButton *btnRate3;
@property (strong, nonatomic) IBOutlet UIButton *btnRate4;
@property (strong, nonatomic) IBOutlet UIButton *btnRate5;
@property (strong, nonatomic) IBOutlet UIButton *btnAction;
@end
