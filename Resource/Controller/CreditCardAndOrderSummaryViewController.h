//
//  CreditCardAndOrderSummaryViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 9/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Branch.h"
#import "CustomerTable.h"
#import "CustomViewVoucher.h"
#import "Promotion.h"
#import "Receipt.h"
#import "RewardRedemption.h"
#import "Promotion.h"
#import "SaveReceipt.h"


@interface CreditCardAndOrderSummaryViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UITableView *tbvTotal;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbvTotalHeightConstant;
@property (strong, nonatomic) IBOutlet CustomViewVoucher *voucherView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonHeight;
@property (strong, nonatomic) IBOutlet UIButton *btnAddRemoveMenu;
@property (strong, nonatomic) Branch *branch;
@property (strong, nonatomic) CustomerTable *customerTable;
@property (strong, nonatomic) Receipt *receipt;
@property (strong, nonatomic) Receipt *buffetReceipt;
@property (strong, nonatomic) RewardRedemption *rewardRedemption;
@property (strong, nonatomic) Promotion *promotion;
@property (nonatomic) NSInteger fromReceiptSummaryMenu;
@property (nonatomic) NSInteger fromOrderDetailMenu;
@property (nonatomic) NSInteger fromRewardRedemption;
@property (nonatomic) NSInteger fromHotDealDetail;
@property (nonatomic) NSInteger fromLuckyDraw;
@property (nonatomic) NSInteger addRemoveMenu;
- (IBAction)addRemoveMenu:(id)sender;
- (IBAction)goBack:(id)sender;
-(IBAction)unwindToCreditCardAndOrderSummary:(UIStoryboardSegue *)segue;
- (IBAction)shareMenuToOrder:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnShareMenuToOrder;

@end
