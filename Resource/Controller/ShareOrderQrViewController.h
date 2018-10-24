//
//  ShareOrderQrViewController.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 23/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"

@interface ShareOrderQrViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (nonatomic) NSInteger shareOrderReceiptID;


- (IBAction)goBack:(id)sender;

@end
