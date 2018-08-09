//
//  PersonalDataViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface PersonalDataViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
- (IBAction)goBack:(id)sender;

@end
