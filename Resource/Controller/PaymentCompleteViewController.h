//
//  PaymentCompleteViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 14/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"


@interface PaymentCompleteViewController : CustomViewController<CAAnimationDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnSaveToCameraRoll;
@property (strong, nonatomic) IBOutlet UIButton *btnOrderBuffet;

@property (strong, nonatomic) Receipt *receipt;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgVwCheckTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnOrderBuffetHeight;
@property (nonatomic) NSInteger numberOfGift;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwCheck;
@property (strong, nonatomic) IBOutlet UIButton *btnBackToHome;
@property (nonatomic) NSInteger orderBuffet;
@property (nonatomic) NSInteger goToHotDeal;


- (IBAction)button1Clicked:(id)sender;
- (IBAction)button2Clicked:(id)sender;
- (IBAction)orderBuffet:(id)sender;
@end
