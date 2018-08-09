//
//  OrderDetailViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 10/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"


@interface OrderDetailViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UITableView *tbvRating;
@property (strong, nonatomic) Receipt *receipt;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbvRatingHeight;

-(IBAction)unwindToOrderDetail:(UIStoryboardSegue *)segue;
- (IBAction)goBack:(id)sender;
-(void)reloadTableView;
- (IBAction)refresh:(id)sender;


@end
