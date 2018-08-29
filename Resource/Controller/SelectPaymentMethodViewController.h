//
//  SelectPaymentMethodViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 14/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "CreditCard.h"

@interface SelectPaymentMethodViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) CreditCard *creditCard;
- (IBAction)dismissViewController:(id)sender;

@end
