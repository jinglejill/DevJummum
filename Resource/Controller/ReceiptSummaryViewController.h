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
-(IBAction)unwindToReceiptSummary:(UIStoryboardSegue *)segue;
- (IBAction)goBack:(id)sender;
- (void)reloadTableView;
- (IBAction)refresh:(id)sender;
-(void)segueToOrderDetailAuto:(Receipt *)receipt;
@end
