//
//  RecommendShopViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RecommendShopViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelTextView.h"
#import "CustomTableViewHeaderFooterOkCancel.h"
#import "RecommendShop.h"
#import "Setting.h"


@interface RecommendShopViewController ()
{
    RecommendShop *_recommendShop;
    NSString *_strPlaceHolder;
}
@end

@implementation RecommendShopViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelTextView = @"CustomTableViewCellLabelTextView";
static NSString * const reuseIdentifierHeaderFooterOkCancel = @"CustomTableViewHeaderFooterOkCancel";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize pickerVw;
@synthesize tbvAction;
@synthesize topViewHeight;
@synthesize bottomViewHeight;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomViewHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = cSystem5;
    if([textView.text isEqualToString:_strPlaceHolder])
    {
        textView.text = @"";
    }
    
    
    [textView becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    _recommendShop.text = [Utility trimString:textView.text];
    if([textView.text isEqualToString:@""])
    {
        textView.text = _strPlaceHolder;
        textView.textColor = mPlaceHolder;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"แนะนำร้านอาหาร"];
    lblNavTitle.text = title;
    NSString *message = [Language getText:@"- แนะนำร้านอาหาร/สาขา/เบอร์โทร ที่คุณต้องการให้ JUMMUM เข้าไปติดต่อ \n- ให้เหตุผลที่คุณต้องการให้ร้านอาหารโปรดของคุณมาอยู่ในแอพ JUMMUM"];
    _strPlaceHolder = message;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.separatorColor = [UIColor clearColor];
    tbvData.backgroundColor = [UIColor whiteColor];
    _recommendShop = [[RecommendShop alloc]init];
    
    
    
    tbvAction.delegate = self;
    tbvAction.dataSource = self;
    tbvAction.backgroundColor = [UIColor whiteColor];
    tbvAction.scrollEnabled = NO;
    
    
    

    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelTextView bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelTextView];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierHeaderFooterOkCancel bundle:nil];
        [tbvAction registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifierHeaderFooterOkCancel];
    }
    
    
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvData])
    {
        return 1;
    }
    else
    {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if([tableView isEqual:tbvData])
    {
        CustomTableViewCellLabelTextView *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelTextView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        NSString *message = [Language getText:@"แนะนำร้านอาหาร/สาขา"];
        NSString *strTitle = message;
        
        
        
        UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
        UIColor *color = cSystem1;;
        NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
        
        
        UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
        UIColor *color2 = cSystem4;
        NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
        NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
        
        
        [attrString appendAttributedString:attrString2];
        cell.lblTitle.attributedText = attrString;
        
        
        
        cell.txvValue.tag = 3;
        cell.txvValue.delegate = self;
        cell.txvValue.text = _recommendShop.text;
        if([cell.txvValue.text isEqualToString:@""])
        {
            cell.txvValue.text = _strPlaceHolder;
            cell.txvValue.textColor = mPlaceHolder;
        }
        else
        {
            cell.txvValue.textColor = cSystem5;
        }
        [cell.txvValue.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [cell.txvValue.layer setBorderWidth:0.5];
        
        
        
        //The rounded corner part, where you specify your view's corner radius:
        cell.txvValue.layer.cornerRadius = 5;
        cell.txvValue.clipsToBounds = YES;
        cell.txvValueHeight.constant = tableView.frame.size.height - 45;
        [cell.txvValue setInputAccessoryView:self.toolBar];
        
        
        return cell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    if([tableView isEqual:tbvData])
    {
        if(item == 0)
        {
            return tableView.frame.size.height;
        }
    }
    
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvAction])
    {
        CustomTableViewHeaderFooterOkCancel *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierHeaderFooterOkCancel];
        
        
        
        [footerView.btnOk addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [footerView.btnCancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonDesign:footerView.btnOk];
        [self setButtonDesign:footerView.btnCancel];
        
        
        return footerView;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvAction])
    {
        return 8+30+8+30;
    }
    return 0;
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)submit:(id)sender
{
    [self submit];
}

-(void)submit
{
    [self.view endEditing:YES];
    
    
    if(![self validate])
    {
        return;
    }
    [self loadingOverlayView];
    
    
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    _recommendShop.userAccountID = userAccount.userAccountID;
    _recommendShop.modifiedUser = [Utility modifiedUser];
    _recommendShop.modifiedDate = [Utility currentDateTime];
    [self.homeModel insertItems:dbRecommendShop withData:_recommendShop actionScreen:@"insert recommend shop"];
}

-(void)cancel:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)itemsInserted
{
    [self removeOverlayViews];
    
    
    NSString *message = [Language getText:@"ขอบคุณสำหรับการแนะนำร้านครั้งนี้ค่ะ"];
    [self showAlert:@"" message:message method:@selector(unwindToMe)];
}

-(BOOL)validate
{
    UITextView *textView = [self.view viewWithTag:3];
    if([textView.text isEqualToString:_strPlaceHolder])
    {
        NSString *message = [Language getText:@"กรุณาใส่ร้านอาหารที่คุณต้องการแนะนำ"];
        [self blinkAlertMsg:message];
        return NO;
    }
    
    
    return YES;
}

-(void)unwindToMe
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

@end
