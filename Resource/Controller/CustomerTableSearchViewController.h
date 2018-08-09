//
//  CustomerTableSearchViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 7/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Branch.h"
#import "CustomerTable.h"


@interface CustomerTableSearchViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvCustomerTable;
@property (strong, nonatomic) IBOutlet UIView *vwBottomShadow;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) Branch *branch;
@property (strong, nonatomic) CustomerTable *customerTable;
@property (nonatomic) NSInteger fromCreditCardAndOrderSummaryMenu;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
-(IBAction)goBackHome:(id)sender;
-(IBAction)unwindToCustomerTableSearch:(UIStoryboardSegue *)segue;


@end
