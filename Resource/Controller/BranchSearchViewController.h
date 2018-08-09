//
//  BranchSearchViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 28/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"


@interface BranchSearchViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvBranch;
@property (strong, nonatomic) IBOutlet UISearchBar *sbText;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
-(IBAction)unwindToBranchSearch:(UIStoryboardSegue *)segue;
- (IBAction)goBack:(id)sender;
@end
