//
//  ShareMenuToOrderViewController.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import "SaveReceipt.h"


@interface ShareMenuToOrderViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) SaveReceipt *saveReceipt;
@property (strong, nonatomic) NSMutableArray *saveOrderTakingList;
@property (strong, nonatomic) NSMutableArray *saveOrderNoteList;


- (IBAction)goBack:(id)sender;

@end
