//
//  RewardViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 4/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface RewardViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

- (IBAction)goBack:(id)sender;
-(IBAction)unwindToReward:(UIStoryboardSegue *)segue;
@end
