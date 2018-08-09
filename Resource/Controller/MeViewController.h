//
//  MeViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface MeViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tbvMe;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

-(IBAction)unwindToMe:(UIStoryboardSegue *)segue;
-(void)segueToReceiptSummaryAuto;
@end
