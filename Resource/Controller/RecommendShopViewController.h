//
//  RecommendShopViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface RecommendShopViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UITableView *tbvAction;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerVw;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;



- (IBAction)goBack:(id)sender;

@end
