//
//  VoucherCodeListViewController.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 28/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import "Branch.h"


@interface VoucherCodeListViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) Branch *branch;
//@property (strong, nonatomic) NSMutableArray *promotionList;
//@property (strong, nonatomic) NSMutableArray *rewardRedemptionList;
@property (strong, nonatomic) NSString *selectedVoucherCode;
- (IBAction)dismissViewController:(id)sender;
@end
