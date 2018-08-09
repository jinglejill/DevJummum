//
//  BasketViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 22/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Branch.h"
#import "CustomerTable.h"
#import "CustomViewVoucher.h"


@interface BasketViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvOrder;
@property (strong, nonatomic) IBOutlet UITableView *tbvTotal;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbvTotalHeightConstant;
@property (strong, nonatomic) IBOutlet CustomViewVoucher *voucherView;
@property (strong, nonatomic) Branch *branch;
@property (strong, nonatomic) CustomerTable *customerTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonHeight;


-(IBAction)unwindToBasket:(UIStoryboardSegue *)segue;
-(IBAction)unwindToMenuSelection:(id)sender;
- (IBAction)deleteAll:(id)sender;

@end
