//
//  CommentViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Rating.h"

@interface CommentViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UITableView *tbvAction;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerVw;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (strong, nonatomic) Rating *rating;
@property (nonatomic) BOOL viewComment;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbvActionHeight;


- (IBAction)goBack:(id)sender;

@end
