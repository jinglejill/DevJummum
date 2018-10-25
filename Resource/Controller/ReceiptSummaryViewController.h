//
//  ReceiptSummaryViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"


@interface ReceiptSummaryViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (nonatomic) BOOL goToBuffetOrder;
@property (strong, nonatomic) Receipt *orderItAgainReceipt;

- (IBAction)goBack:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)shareOrder:(id)sender;
- (IBAction)unwindToReceiptSummary:(UIStoryboardSegue *)segue;
- (void)reloadTableView;
- (void)segueToOrderDetailAuto:(Receipt *)receipt;
- (IBAction)joinOrder:(id)sender;

@end
