//
//  ShowQRToPayViewController.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 2/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"

@interface ShowQRToPayViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
    @property (strong, nonatomic) IBOutlet UIButton *btnBackFalse;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonHeight;
@property (strong, nonatomic) Receipt *receipt;
@property (nonatomic) NSInteger goToHotDeal;
@property (nonatomic) NSInteger fromReceiptSummary;
@property (nonatomic) NSInteger receiptID;
    
    
- (IBAction)goBack:(id)sender;
-(IBAction)unwindToShowQRToPay:(UIStoryboardSegue *)segue;
-(void)reloadVc;

@end
