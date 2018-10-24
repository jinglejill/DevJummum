//
//  JoinOrderViewController.h
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"

@interface JoinOrderViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
- (IBAction)scanToJoin:(id)sender;


- (IBAction)goBack:(id)sender;
-(IBAction)unwindToJoinOrder:(UIStoryboardSegue *)segue;
@end
