//
//  RegisterNowViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 2/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "UserAccount.h"


@interface RegisterNowViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
@property (strong, nonatomic) IBOutlet UIButton *btnCreateAccount;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (strong, nonatomic) UserAccount *userAccount;

- (IBAction)datePickerChanged:(id)sender;
- (IBAction)createAccount:(id)sender;
- (IBAction)goBack:(id)sender;


@end
