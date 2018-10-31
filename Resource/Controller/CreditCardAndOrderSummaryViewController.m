//
//  CreditCardAndOrderSummaryViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 9/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CreditCardAndOrderSummaryViewController.h"
#import "PaymentCompleteViewController.h"
#import "SelectPaymentMethodViewController.h"
#import "QRCodeScanTableViewController.h"
#import "CustomerTableSearchViewController.h"
#import "VoucherCodeListViewController.h"
#import "ShareMenuToOrderViewController.h"
#import "CustomTableViewCellCreditCard.h"
#import "CustomTableViewCellImageLabelRemove.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellVoucherCode.h"
#import "CustomTableViewCellVoucherCodeExist.h"
#import "CustomTableViewHeaderFooterButton.h"
#import "CustomTableViewCellLabelLabel.h"
#import "CustomTableViewCellLabelTextView.h"
#import "CreditCard.h"
#import "SharedCurrentUserAccount.h"
#import "Menu.h"
#import "SpecialPriceProgram.h"
#import "Receipt.h"
#import "OrderTaking.h"
#import "OrderNote.h"
#import "OmiseSDK.h"
#import "DevJummum-Swift.h"
#import "UserAccount.h"
#import "PromotionMenu.h"
#import "Promotion.h"
#import "UserPromotionUsed.h"
#import "Setting.h"
#import "MenuType.h"
#import "Message.h"
#import "RewardRedemption.h"
#import "UserRewardRedemptionUsed.h"
#import "VoucherCode.h"
#import "SaveReceipt.h"
#import "SaveOrderTaking.h"
#import "SaveOrderNote.h"


@interface CreditCardAndOrderSummaryViewController ()
{
    CreditCard *_creditCard;
    NSMutableArray *_orderTakingList;
    
    float _totalAmount;
    float _specialPriceDiscount;
    float _discountValue;
    float _serviceChargeValue;
    float _vatValue;
    float _netTotal;
    float _beforeVat;
    Receipt *_receipt;
    NSIndexPath *_currentScrollIndexPath;
    
    NSString *_strPlaceHolder;
    NSString *_remark;
    UIButton *_btnPay;
    NSMutableArray *_promotionList;
    NSMutableArray *_rewardRedemptionList;
    NSString *_selectedVoucherCode;
    BOOL _showGuideMessage;
    NSInteger _numberOfGift;
}
@end

@implementation CreditCardAndOrderSummaryViewController
static NSString * const reuseIdentifierCredit = @"CustomTableViewCellCreditCard";
static NSString * const reuseIdentifierImageLabelRemove = @"CustomTableViewCellImageLabelRemove";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierVoucherCode = @"CustomTableViewCellVoucherCode";
static NSString * const reuseIdentifierVoucherCodeExist = @"CustomTableViewCellVoucherCodeExist";
static NSString * const reuseIdentifierHeaderFooterButton = @"CustomTableViewHeaderFooterButton";
static NSString * const reuseIdentifierLabelLabel = @"CustomTableViewCellLabelLabel";
static NSString * const reuseIdentifierLabelTextView = @"CustomTableViewCellLabelTextView";



@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize voucherView;
@synthesize branch;
@synthesize customerTable;
@synthesize tbvTotal;
@synthesize tbvTotalHeightConstant;
@synthesize fromReceiptSummaryMenu;
@synthesize fromOrderDetailMenu;
@synthesize topViewHeight;
@synthesize bottomButtonHeight;
@synthesize btnAddRemoveMenu;
@synthesize buffetReceipt;
@synthesize fromRewardRedemption;
@synthesize rewardRedemption;
@synthesize fromHotDealDetail;
@synthesize promotion;
@synthesize fromLuckyDraw;
@synthesize addRemoveMenu;
@synthesize receipt;//orderItAgain
@synthesize btnShareMenuToOrder;


-(IBAction)unwindToCreditCardAndOrderSummary:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isMemberOfClass:[SelectPaymentMethodViewController class]])
    {
        SelectPaymentMethodViewController *vc = segue.sourceViewController;
        _creditCard = vc.creditCard;
        if(_creditCard.primaryCard)
        {
            _creditCard.saveCard = 1;
        }
        [tbvData reloadData];
    }
    else if([segue.sourceViewController isMemberOfClass:[CustomerTableSearchViewController class]])
    {
        CustomerTableSearchViewController *vc = segue.sourceViewController;
        customerTable = vc.customerTable;
        [tbvData reloadData];
    }
    else if([segue.sourceViewController isMemberOfClass:[QRCodeScanTableViewController class]])
    {
        QRCodeScanTableViewController *vc = segue.sourceViewController;
        customerTable = vc.customerTable;
        [tbvData reloadData];
    }
    else if([segue.sourceViewController isMemberOfClass:[VoucherCodeListViewController class]])
    {
        VoucherCodeListViewController *vc = segue.sourceViewController;
        
        _selectedVoucherCode = vc.selectedVoucherCode;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
        CustomTableViewCellVoucherCodeExist *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
        cell.txtVoucherCode.text = _selectedVoucherCode;
        if(![Utility isStringEmpty:_selectedVoucherCode])
        {
            [self confirmVoucherCode:_selectedVoucherCode];
        }        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if(textField.tag == 31)
    {
        [textField resignFirstResponder];
        [self confirmVoucherCode];
    }
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder)
    {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    }
    else
    {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
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
    _remark = [Utility trimString:textView.text];
    if([textView.text isEqualToString:@""])
    {
        textView.text = _strPlaceHolder;
        textView.textColor = mPlaceHolder;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _currentScrollIndexPath = tbvData.indexPathsForVisibleRows.firstObject;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:.25 animations:^{
        if(_currentScrollIndexPath)
        {
            [tbvData scrollToRowAtIndexPath:_currentScrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];
    
    
    if(!_showGuideMessage)
    {
        if(fromReceiptSummaryMenu || fromOrderDetailMenu || fromRewardRedemption || fromHotDealDetail || fromLuckyDraw)
        {
            _showGuideMessage = YES;
            NSMutableDictionary *dontShowMessageMenuUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"MessageMenuUpdate"];
            if(dontShowMessageMenuUpdate)
            {
                UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            
                NSString *checked = [dontShowMessageMenuUpdate objectForKey:userAccount.username];
                if(!checked)
                {
                    [self performSegueWithIdentifier:@"segMessageBoxWithDismiss" sender:self];
                }
            }
            else
            {
                [self performSegueWithIdentifier:@"segMessageBoxWithDismiss" sender:self];
            }
        }
    }
}

- (IBAction)goBack:(id)sender
{
    if(fromReceiptSummaryMenu)
    {
        [self performSegueWithIdentifier:@"segUnwindToReceiptSummary" sender:self];
    }
    else if(fromOrderDetailMenu)
    {
        [self performSegueWithIdentifier:@"segUnwindToOrderDetail" sender:self];
    }
    else if(fromRewardRedemption)
    {
        [self performSegueWithIdentifier:@"segUnwindToRewardRedemption" sender:self];
    }
    else if(fromHotDealDetail)
    {
        [self performSegueWithIdentifier:@"segUnwindToHotDealDetail" sender:self];
    }
    else if(fromLuckyDraw)
    {
        [OrderTaking removeCurrentOrderTakingList];
        [self performSegueWithIdentifier:@"segUnwindToLuckyDraw" sender:self];
    }
    else
    {
        [CreditCard setCurrentCreditCard:_creditCard];
        [self performSegueWithIdentifier:@"segUnwindToBasket" sender:self];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect toView:nil];
    
    CGSize kbSize = kbRect.size;
    
    
    
    // Assign new frame to your view
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.view setFrame:CGRectMake(0,kbSize.height*-1,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
                     }
                     completion:nil
     ];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                         [self.view layoutSubviews];
                     }
                     completion:nil
     ];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == 31)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag == 31)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];


        [self.view endEditing:YES];

        return YES;
    }

    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 31)
    {
        
    }
    else
    {
        UIView *vwInvalid = [self.view viewWithTag:textField.tag+10];
        vwInvalid.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            _creditCard.firstName = [Utility trimString:textField.text];
        }
        break;
        case 2:
        {
            _creditCard.lastName = [Utility trimString:textField.text];
        }
        break;
        case 3:
        {
            _creditCard.creditCardNo = [Utility removeSpace:[Utility trimString:textField.text]];
        }
        break;
        case 4:
        {
            _creditCard.month = [textField.text integerValue];
        }
        break;
        case 5:
        {
            _creditCard.year = [textField.text integerValue];
        }
        break;
        case 6:
        {
            _creditCard.ccv = [Utility trimString:textField.text];
        }
        break;
        case 31:
        {
            _selectedVoucherCode = [Utility trimString:textField.text];
        }
            break;
        default:
        break;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomButtonHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(void)loadView
{
    [super loadView];
    
    
    NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
    _orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    NSString *title = [Language getText:@"ชำระเงิน"];
    lblNavTitle.text = title;
    NSString *message = [Language getText:@"ใส่หมายเหตุที่ต้องการแจ้งเพิ่มเติมกับทางร้านอาหาร"];
    _strPlaceHolder = message;

    
    
    _promotionList = [[NSMutableArray alloc]init];
    _rewardRedemptionList = [[NSMutableArray alloc]init];
    _remark = receipt?receipt.remark:@"";
    
    if(fromReceiptSummaryMenu || fromOrderDetailMenu || fromRewardRedemption || fromHotDealDetail || fromLuckyDraw)
    {
        btnAddRemoveMenu.hidden = NO;
    }
    else
    {
        btnAddRemoveMenu.hidden = YES;
    }
    
    
    
    //set credit card
    _creditCard = [CreditCard getCurrentCreditCard];
    if(!_creditCard)
    {
        UserAccount *userAccount = [UserAccount getCurrentUserAccount];
        NSMutableDictionary *dicCreditCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"creditCard"] mutableCopy];
        if(dicCreditCard)
        {
            NSMutableArray *creditCardList = [dicCreditCard objectForKey:userAccount.username];
            if(creditCardList && [creditCardList count] > 0)
            {
                _creditCard = [CreditCard getPrimaryCard:creditCardList];
            }
            else
            {
                _creditCard = [[CreditCard alloc]init];
                _creditCard.saveCard = 1;
            }
        }
        else
        {
            _creditCard = [[CreditCard alloc]init];
            _creditCard.saveCard = 1;
        }
    }
    

    
    
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvTotal.delegate = self;
    tbvTotal.dataSource = self;
    [tbvTotal setSeparatorColor:[UIColor clearColor]];
    tbvTotal.scrollEnabled = NO;
    

    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierCredit bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierCredit];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierImageLabelRemove bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierImageLabelRemove];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelTextView bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelTextView];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
        [tbvTotal registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierHeaderFooterButton bundle:nil];
        [tbvTotal registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifierHeaderFooterButton];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierVoucherCode bundle:nil];
        [tbvTotal registerNib:nib forCellReuseIdentifier:reuseIdentifierVoucherCode];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierVoucherCodeExist bundle:nil];
        [tbvTotal registerNib:nib forCellReuseIdentifier:reuseIdentifierVoucherCodeExist];
    }

    [[NSBundle mainBundle] loadNibNamed:@"CustomViewVoucher" owner:self options:nil];
    [voucherView.btnDelete setTitle:[Language getText:@"ลบ"] forState:UIControlStateNormal];
    [voucherView.btnDelete addTarget:self action:@selector(deleteVoucher:) forControlEvents:UIControlEventTouchUpInside];

    
    [self loadingOverlayView];
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbPromotionAndRewardRedemption withData:@[branch,userAccount]];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([tableView isEqual:tbvData])
    {
        return 4;
    }
    else if([tableView isEqual:tbvTotal])
    {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if([tableView isEqual:tbvData])
    {
        if(section == 0)//ชื่อร้าน
        {
            return 1;
        }
        else if(section == 1)//credit card
        {
            float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
            if(sumSpecialPrice == 0)
            {
                return 0;
            }
            else
            {
                NSInteger selectCreditCard = 0;//has card saved
                UserAccount *userAccount = [UserAccount getCurrentUserAccount];
                NSMutableDictionary *dicCreditCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"creditCard"] mutableCopy];
                if(dicCreditCard)
                {
                    NSMutableArray *creditCardList = [dicCreditCard objectForKey:userAccount.username];
                    if(creditCardList && [creditCardList count] > 0)
                    {
                        selectCreditCard = 1;
                    }
                }
                
                if(!_creditCard.primaryCard && selectCreditCard)
                {
                    return 3;
                }
                
                return 2;
            }
        }
        else if(section == 2)
        {
            return [_orderTakingList count]+1;
        }
        else if(section == 3)
        {
            return 1;
        }
    }
    else if([tableView isEqual:tbvTotal])
    {
        float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
        if(sumSpecialPrice == 0)//buffet
        {
            tbvTotalHeightConstant.constant = 26+44;
            return 1;
        }
        else
        {
            float sumSpecialPriceDiscount = [OrderTaking getSumSpecialPriceDiscount:_orderTakingList];
            float tbvTotalHeight = 26*2+44;
            float sumSpecialPriceDiscountHeight = sumSpecialPriceDiscount == 0?0:26;
            float chooseVoucherCodeHeight = [_promotionList count]+[_rewardRedemptionList count] > 0?66:38;
            float serviceChargeHeight = branch.serviceChargePercent > 0?26:0;
            float vatHeight = branch.percentVat > 0?26:0;
            float netTotalHeight = branch.serviceChargePercent+branch.percentVat > 0?26:0;
            float beforeVatHeight = branch.serviceChargePercent>0 && branch.percentVat>0?26:0;
            tbvTotalHeightConstant.constant = tbvTotalHeight+sumSpecialPriceDiscountHeight+chooseVoucherCodeHeight+serviceChargeHeight+vatHeight+netTotalHeight+beforeVatHeight;
            
            return 8;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvData])
    {
        if(section == 0)
        {
            CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblText.text = [NSString stringWithFormat:[Language getText:@"ร้าน %@"],branch.name];
            cell.lblText.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            [cell.lblText sizeToFit];
            cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
            
            
            if(buffetReceipt)
            {
                CustomerTable *buffetTable = [CustomerTable getCustomerTable:buffetReceipt.customerTableID];
                NSString *customerTableName = buffetTable.tableName;
                cell.lblValue.text = [NSString stringWithFormat:[Language getText:@"เลขโต๊ะ: %@"],customerTableName];
                cell.lblValue.textColor = cSystem4;
            }
            else if(fromLuckyDraw)
            {
                cell.lblValue.text = [NSString stringWithFormat:[Language getText:@"เลขโต๊ะ: %@"],customerTable.tableName];
                cell.lblValue.textColor = cSystem4;
            }
            else
            {
                if(customerTable)
                {
                    NSString *customerTableName = customerTable.tableName;
                    cell.lblValue.text = [NSString stringWithFormat:[Language getText:@"เลขโต๊ะ: %@"],customerTableName];
                    cell.lblValue.textColor = cSystem4;
                }
                else
                {
                    cell.lblValue.text = [Language getText:@"เลือกโต๊ะ"];
                    cell.lblValue.textColor = cSystem2;
                }
            }
            cell.lblValue.hidden = NO;
            
            
            
            return  cell;
        }
        else if(section == 1)
        {
            switch (item)
            {
                case 0:
                {
                    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
                    if (!cell) {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    }
                    
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    NSString *message = [Language getText:@"การชำระเงิน ด้วยบัตรเครดิต/เดบิต"];
                    cell.textLabel.text = message;
                    cell.textLabel.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
                    cell.textLabel.textColor = cSystem1;
                    
                    
                    return cell;
                }
                    break;
                case 1:
                {
                    if(!_creditCard.primaryCard)
                    {
                        CustomTableViewCellCreditCard *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCredit];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.txtFirstNameWidthConstant.constant = (cell.frame.size.width-16*3)/2;
                        cell.txtMonthWidthConstant.constant = (cell.frame.size.width-16*3)/2;
                        
                        
                        cell.txtFirstName.tag = 1;
                        cell.txtLastName.tag = 2;
                        cell.txtCardNo.tag = 3;
                        cell.txtMonth.tag = 4;
                        cell.txtYear.tag = 5;
                        cell.txtCCV.tag = 6;
                        cell.vwFirstName.tag = 11;
                        cell.vwLastName.tag = 12;
                        cell.vwCardNo.tag = 13;
                        cell.vwMonth.tag = 14;
                        cell.vwYear.tag = 15;
                        cell.vwCCV.tag = 16;
                        cell.imgCreditCardBrand.tag = 21;
                        
                        
                        cell.txtFirstName.delegate = self;
                        cell.txtLastName.delegate = self;
                        cell.txtCardNo.delegate = self;
                        cell.txtMonth.delegate = self;
                        cell.txtYear.delegate = self;
                        cell.txtCCV.delegate = self;
                        
                        
                        [cell.txtFirstName setInputAccessoryView:self.toolBar];
                        [cell.txtLastName setInputAccessoryView:self.toolBar];
                        [cell.txtCardNo setInputAccessoryView:self.toolBarNext];
                        [cell.txtMonth setInputAccessoryView:self.toolBar];
                        [cell.txtYear setInputAccessoryView:self.toolBar];
                        [cell.txtCCV setInputAccessoryView:self.toolBar];
                        
                        
                        cell.txtFirstName.returnKeyType = UIReturnKeyNext;
                        cell.txtLastName.returnKeyType = UIReturnKeyNext;
                        
                        
                        cell.vwFirstName.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        cell.vwLastName.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        cell.vwCardNo.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        cell.vwMonth.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        cell.vwYear.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        cell.vwCCV.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        
                        
                        
                        cell.txtFirstName.placeholder = [Language getText:@"ชื่อ"];
                        cell.txtLastName.placeholder = [Language getText:@"นามสกุล"];
                        cell.txtCardNo.placeholder = [Language getText:@"หมายเลขบัตร 16 หลัก"];
                        cell.txtMonth.placeholder = [Language getText:@"เดือนที่หมดอายุ (MM)"];
                        cell.txtYear.placeholder = [Language getText:@"ปีที่หมดอายุ (YYYY)"];
                        cell.txtCCV.placeholder = [Language getText:@"รหัสความปลอดภัย"];
                        cell.lblCCVGuide.text = [Language getText:@"เลข 3 หลักที่ด้านหลังบัตรของคุณ"];
                        cell.lblSave.text = [Language getText:@"บันทึกบัตรนี้"];
                        cell.lblDeleteCard.text = [Language getText:@"คุณสามารถลบบัตรใบนี้ได้ที่เมนูโพรไฟล์ส่วนตัว"];
                        
                        
                        
                        cell.txtFirstName.text = _creditCard.firstName;
                        cell.txtLastName.text = _creditCard.lastName;                        
                        cell.txtCardNo.text = [OMSCardNumber format:_creditCard.creditCardNo];
                        cell.txtMonth.text = _creditCard.month == 0?@"":[NSString stringWithFormat:@"%02ld",_creditCard.month];
                        cell.txtYear.text = _creditCard.year == 0?@"":[NSString stringWithFormat:@"%02ld",_creditCard.year];;
                        cell.txtCCV.text = _creditCard.ccv;
                        
                        
                        cell.txtFirstName.autocapitalizationType = UITextAutocapitalizationTypeWords;
                        cell.txtLastName.autocapitalizationType = UITextAutocapitalizationTypeWords;
                        cell.txtCardNo.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        cell.txtMonth.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        cell.txtYear.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        cell.txtCCV.autocapitalizationType = UITextAutocapitalizationTypeNone;
                        
                        
                        cell.swtSave.on = _creditCard.saveCard;
                        [cell.swtSave addTarget:self action:@selector(swtSaveDidChange:) forControlEvents:UIControlEventValueChanged];
                        [cell.txtCardNo addTarget:self action:@selector(txtCardNoDidChange:) forControlEvents:UIControlEventEditingChanged];
                        [cell.txtMonth addTarget:self action:@selector(txtMonthDidChange:) forControlEvents:UIControlEventEditingChanged];
                        [cell.txtYear addTarget:self action:@selector(txtYearDidChange:) forControlEvents:UIControlEventEditingChanged];
                        
                        
                        
                        NSInteger cardBrand = [OMSCardNumber brandForPan:_creditCard.creditCardNo];
                        switch (cardBrand)
                        {
                            case OMSCardBrandJCB:
                            {
                                cell.imgCreditCardBrand.hidden = NO;
                                cell.imgCreditCardBrand.image = [UIImage imageNamed:@"jcb.png"];
                            }
                                break;
                            case OMSCardBrandAMEX:
                            {
                                cell.imgCreditCardBrand.hidden = NO;
                                cell.imgCreditCardBrand.image = [UIImage imageNamed:@"americanExpress.png"];
                            }
                                break;
                            case OMSCardBrandVisa:
                            {
                                cell.imgCreditCardBrand.hidden = NO;
                                cell.imgCreditCardBrand.image = [UIImage imageNamed:@"visa.png"];
                            }
                                break;
                            case OMSCardBrandMasterCard:
                            {
                                cell.imgCreditCardBrand.hidden = NO;
                                cell.imgCreditCardBrand.image = [UIImage imageNamed:@"masterCard.png"];
                            }
                                break;
                            default:
                            {
                                cell.imgCreditCardBrand.hidden = YES;
                            }
                                break;
                        }
                        
                        return cell;
                    }
                    else
                    {
                        CustomTableViewCellImageLabelRemove *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageLabelRemove];
                        NSInteger cardBrand = [OMSCardNumber brandForPan:_creditCard.creditCardNo];
                        switch (cardBrand)
                        {
                            case OMSCardBrandJCB:
                            {
                                cell.imageView.image = [UIImage imageNamed:@"jcb.png"];
                            }
                                break;
                            case OMSCardBrandAMEX:
                            {
                                cell.imageView.image = [UIImage imageNamed:@"americanExpress.png"];
                            }
                                break;
                            case OMSCardBrandVisa:
                            {
                                cell.imageView.image = [UIImage imageNamed:@"visa.png"];
                            }
                                break;
                            case OMSCardBrandMasterCard:
                            {
                                cell.imageView.image = [UIImage imageNamed:@"masterCard.png"];
                            }
                                break;
                            default:
                                break;
                        }
                        
                        
                        
                        NSString *strCreditCardNo = [Utility hideCreditCardNo:_creditCard.creditCardNo];
                        cell.lblValue.text = strCreditCardNo;
                        cell.lblValue.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                        
                        
                        
                        
                        [cell.btnRemove setTitle:@">" forState:UIControlStateNormal];
                        [cell.btnRemove addTarget:self action:@selector(addCreditCard:) forControlEvents:UIControlEventTouchUpInside];
                        return cell;
                    }
                    
                }
                    break;
                case 2:
                {
                    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cellValue1"];
                    if (!cell)
                    {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellValue1"];
                    }
                    
                    
                    cell.textLabel.text = [Language getText:@"เลือกบัตรเครดิต/เดบิต"];
                    cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                    cell.textLabel.textColor = cSystem4;
                    cell.detailTextLabel.text = @">";
                    cell.detailTextLabel.textColor = cSystem4;
                    
                    
                    
                    return cell;
                }
                default:
                    break;
            }
        }
        else if(section == 2)
        {
            if(item == 0)
            {
                CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.lblText.text = [Language getText:@"สรุปรายการอาหาร"];
                cell.lblText.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                [cell.lblText sizeToFit];
                
                
                cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
                cell.lblValue.hidden = YES;
                
                
                return  cell;
            }
            else
            {
                CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                OrderTaking *orderTaking = _orderTakingList[item-1];
                Menu *menu = [Menu getMenu:orderTaking.menuID branchID:branch.branchID];
                cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
                
                
                //menu
                if(orderTaking.takeAway)
                {
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"ใส่ห่อ"] attributes:attribute];
                    
                    NSDictionary *attribute2 = @{NSFontAttributeName: font};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                    
                    
                    [attrString appendAttributedString:attrString2];
                    cell.lblMenuName.attributedText = attrString;
                }
                else
                {
                    cell.lblMenuName.text = menu.titleThai;
                }
                [cell.lblMenuName sizeToFit];
                cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height>46?46:cell.lblMenuName.frame.size.height;
                
                
                
                //note
                NSMutableAttributedString *strAllNote;
                NSMutableAttributedString *attrStringRemove;
                NSMutableAttributedString *attrStringAdd;
                NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
                NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:[Language getText:branch.wordNo] attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:[Language getText:branch.wordAdd] attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                    
                    
                    [attrStringAdd appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    strAllNote = attrStringRemove;
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                        [strAllNote appendAttributedString:attrString];
                        [strAllNote appendAttributedString:attrStringAdd];
                    }
                }
                else
                {
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        strAllNote = attrStringAdd;
                    }
                    else
                    {
                        strAllNote = [[NSMutableAttributedString alloc]init];
                    }
                }
                cell.lblNote.attributedText = strAllNote;
                [cell.lblNote sizeToFit];
                cell.lblNoteHeight.constant = cell.lblNote.frame.size.height>40?40:cell.lblNote.frame.size.height;
                
                
                
                float totalAmount = (orderTaking.specialPrice+orderTaking.takeAwayPrice+orderTaking.notePrice) * orderTaking.quantity;
                NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                cell.lblTotalAmount.text = [Utility addPrefixBahtSymbol:strTotalAmount];
                
                
                return cell;
            }
        }
        else if(section == 3)
        {
            CustomTableViewCellLabelTextView *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelTextView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            NSString *message = [Language getText:@"หมายเหตุ"];
            NSString *strTitle = message;
            
            
            
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            UIColor *color = cSystem1;;
            NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:attribute];
            
            
            UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
            UIColor *color2 = cSystem4;
            NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
            
            
            [attrString appendAttributedString:attrString2];
            cell.lblTitle.attributedText = attrString;
            
            
            
            cell.txvValue.tag = 41;
            cell.txvValue.delegate = self;
            cell.txvValue.text = _remark;
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
            [cell.txvValue setInputAccessoryView:self.toolBar];
            
            
            return cell;
        }
    }
    else if([tableView isEqual:tbvTotal])
    {
        switch (item)
        {
            case 0:
            {
                CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
                NSString *strTitle = [NSString stringWithFormat:[Language getText:@"%ld รายการ"],[orderTakingList count]];
                float totalAmount = [OrderTaking getSumPrice:_orderTakingList];
                totalAmount = roundf(totalAmount*100)/100;
                NSString *strTotal = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = NO;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                cell.hidden = NO;
                _totalAmount = totalAmount;
                
                return  cell;
            }
                break;
            case 1:
            {
                CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                float sumSpecialPriceDiscount = [OrderTaking getSumSpecialPriceDiscount:_orderTakingList];
                sumSpecialPriceDiscount = roundf(sumSpecialPriceDiscount*100)/100;
                _specialPriceDiscount = sumSpecialPriceDiscount;
                
                NSString *strSpecialPriceDiscount = [Utility formatDecimal:sumSpecialPriceDiscount withMinFraction:2 andMaxFraction:2];
                strSpecialPriceDiscount = [Utility addPrefixBahtSymbol:strSpecialPriceDiscount];
                strSpecialPriceDiscount = [NSString stringWithFormat:@"-%@",strSpecialPriceDiscount];
                cell.lblTitle.text = [Language getText:@"ส่วนลด"];
                cell.lblAmount.text = strSpecialPriceDiscount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem2;
                cell.hidden = sumSpecialPriceDiscount == 0;
                
                return cell;
                
            }
                break;
            case 2:
            {
                //voucher code
                CustomTableViewCellVoucherCodeExist *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierVoucherCodeExist];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.txtVoucherCode.tag = 31;
                cell.txtVoucherCode.delegate = self;
                cell.txtVoucherCode.text = @"";
                cell.txtVoucherCode.placeholder = [Language getText:@"Voucher code"];
                [self setTextFieldDesign:cell.txtVoucherCode];
                [cell.txtVoucherCode setInputAccessoryView:self.toolBar];
                [cell.txtVoucherCode addTarget:self action:@selector(txtVoucherCodeChanged:) forControlEvents:UIControlEventEditingChanged];
                
                
                cell.btnConfirmWidth.constant = (self.view.frame.size.width - 16*2 - 8)/2;
                [cell.btnConfirm setTitle:[Language getText:@"ยืนยัน"] forState:UIControlStateNormal];
                [cell.btnConfirm addTarget:self action:@selector(confirmVoucherCode) forControlEvents:UIControlEventTouchUpInside];
                [self setButtonDesign:cell.btnConfirm];
                
                
                [cell.btnChooseVoucherCode setTitle:[Language getText:@"คุณมี voucher code สำหรับร้านนี้"] forState:UIControlStateNormal];
                [cell.btnChooseVoucherCode addTarget:self action:@selector(chooseVoucherCode:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.btnChooseVoucherCode.hidden = [_promotionList count]+[_rewardRedemptionList count]==0;

                
                return cell;
            }
                break;
            case 3:
            {
                //after discount - no promoCode
                CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;


                NSString *strTitle = branch.priceIncludeVat?[Language getText:@"ยอดรวม (รวม Vat)"]:[Language getText:@"ยอดรวม"];
                float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
                sumSpecialPrice = roundf(sumSpecialPrice*100)/100;
                NSString *strTotal = [Utility formatDecimal:sumSpecialPrice withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                cell.hidden = NO;
                

                return  cell;
            }
                break;
            case 4:
            {
                //service charge
                CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strServiceCharge = [Utility formatDecimal:branch.serviceChargePercent withMinFraction:0 andMaxFraction:2];
                NSString *strTitle = [NSString stringWithFormat:@"Service charge %@%%",strServiceCharge];
                float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
                sumSpecialPrice = roundf(sumSpecialPrice*100)/100;
                float serviceChargeValue;
                if(branch.priceIncludeVat)
                {
                    sumSpecialPrice = sumSpecialPrice / ((branch.percentVat+100)*0.01);
                }
                serviceChargeValue = branch.serviceChargePercent * sumSpecialPrice * 0.01;
                serviceChargeValue = roundf(serviceChargeValue * 100)/100;
                _serviceChargeValue = serviceChargeValue;
                NSString *strTotal = [Utility formatDecimal:serviceChargeValue withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.textColor = cSystem4;
                cell.hidden = branch.serviceChargePercent == 0;
                
                
                return  cell;
            }
                break;
            case 5:
            {
                //vat
                CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strPercentVat = [Utility formatDecimal:branch.percentVat withMinFraction:0 andMaxFraction:2];
                strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
                sumSpecialPrice = roundf(sumSpecialPrice*100)/100;
                float serviceChargeValue;
                float vatAmount;
                if(branch.priceIncludeVat)
                {
                    sumSpecialPrice = sumSpecialPrice / ((branch.percentVat+100)*0.01);
                }
                serviceChargeValue = branch.serviceChargePercent * sumSpecialPrice * 0.01;
                serviceChargeValue = roundf(serviceChargeValue * 100)/100;
                vatAmount = (sumSpecialPrice+serviceChargeValue)*branch.percentVat/100;
                
                
                vatAmount = roundf(vatAmount*100)/100;
                _vatValue = vatAmount;
                NSString *strAmount = [Utility formatDecimal:vatAmount withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = branch.percentVat==0?@"Vat":strPercentVat;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.textColor = cSystem4;
                cell.hidden = branch.percentVat == 0;
                
                
                return cell;
            }
                break;
            case 6:
            {
                //net total
                CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;


                float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
                sumSpecialPrice = roundf(sumSpecialPrice*100)/100;
                float serviceChargeValue;
                float vatAmount;
                if(branch.priceIncludeVat)
                {
                    sumSpecialPrice = sumSpecialPrice / ((branch.percentVat+100)*0.01);
                }
                serviceChargeValue = branch.serviceChargePercent * sumSpecialPrice * 0.01;
                serviceChargeValue = roundf(serviceChargeValue * 100)/100;
                vatAmount = (sumSpecialPrice+serviceChargeValue)*branch.percentVat/100;
                vatAmount = roundf(vatAmount*100)/100;
                
                
                float netTotalAmount = sumSpecialPrice+serviceChargeValue+vatAmount;
                netTotalAmount = roundf(netTotalAmount*100)/100;
                NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = [Language getText:@"ยอดรวมทั้งสิ้น"];
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                cell.hidden = branch.serviceChargePercent+branch.percentVat == 0;;
                _netTotal = netTotalAmount;


                return cell;
            }
                break;
                case 7:
            {
                //before vat
                CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                
                float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
                sumSpecialPrice = roundf(sumSpecialPrice*100)/100;
                float serviceChargeValue;
                if(branch.priceIncludeVat)
                {
                    sumSpecialPrice = sumSpecialPrice / ((branch.percentVat+100)*0.01);
                }
                serviceChargeValue = branch.serviceChargePercent * sumSpecialPrice * 0.01;
                serviceChargeValue = roundf(serviceChargeValue * 100)/100;
                float beforeVat = sumSpecialPrice+serviceChargeValue;
                beforeVat = roundf(beforeVat*100)/100;
                _beforeVat = beforeVat;
                NSString *strAmount = [Utility formatDecimal:beforeVat withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = [Language getText:@"ราคารวมก่อน Vat"];
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.textColor = cSystem4;
                cell.hidden = branch.serviceChargePercent == 0 || branch.percentVat == 0;
                
                
                return cell;
            }
                break;
            default:
                break;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvData])
    {
        if(section == 0)
        {
            return 44;
        }
        else if(section == 1)
        {
            if(item == 0)
            {
                return 44;
            }
            else if(item == 1)
            {
                if(!_creditCard.primaryCard)
                {
                    return 272;
                }
                else
                {
                    return 44;
                }
            }
            else
            {
                return 44;
            }
        }
        else if(section == 2)
        {
            if(item == 0)
            {
                return 44;
            }
            else
            {
                CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                OrderTaking *orderTaking = _orderTakingList[item-1];
                Menu *menu = [Menu getMenu:orderTaking.menuID branchID:branch.branchID];
                cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
                
                
                //menu
                if(orderTaking.takeAway)
                {
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"ใส่ห่อ"] attributes:attribute];
                    
                    NSDictionary *attribute2 = @{NSFontAttributeName: font};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                    
                    
                    [attrString appendAttributedString:attrString2];
                    cell.lblMenuName.attributedText = attrString;
                }
                else
                {
                    cell.lblMenuName.text = menu.titleThai;
                }
                [cell.lblMenuName sizeToFit];
                cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height>46?46:cell.lblMenuName.frame.size.height;
                
                
                
                //note
                NSMutableAttributedString *strAllNote;
                NSMutableAttributedString *attrStringRemove;
                NSMutableAttributedString *attrStringAdd;
                NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
                NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:[Language getText:branch.wordNo] attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:[Language getText:branch.wordAdd] attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                    
                    
                    [attrStringAdd appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    strAllNote = attrStringRemove;
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                        [strAllNote appendAttributedString:attrString];
                        [strAllNote appendAttributedString:attrStringAdd];
                    }
                }
                else
                {
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        strAllNote = attrStringAdd;
                    }
                    else
                    {
                        strAllNote = [[NSMutableAttributedString alloc]init];
                    }
                }
                cell.lblNote.attributedText = strAllNote;
                [cell.lblNote sizeToFit];
                cell.lblNoteHeight.constant = cell.lblNote.frame.size.height>40?40:cell.lblNote.frame.size.height;
                
                float height = 8+cell.lblMenuNameHeight.constant+2+cell.lblNoteHeight.constant+8;
                return height;
            
            }
        }
        else if(section == 3)
        {
            return 108;
        }
    }
    else if([tableView isEqual:tbvTotal])
    {
        switch (item)
        {
            case 0:
                return 26;
                break;
            case 1:
            {
                float sumSpecialPriceDiscount = [OrderTaking getSumSpecialPriceDiscount:_orderTakingList];
                return sumSpecialPriceDiscount == 0?0:26;
            }
                break;
            case 2:
                return [_promotionList count]+[_rewardRedemptionList count] > 0?66:38;
                break;
            case 3:
                return 26;
                break;
            case 4:
                return branch.serviceChargePercent > 0?26:0;
                break;
            case 5:
                return branch.percentVat > 0?26:0;
                break;
            case 6:
                return branch.serviceChargePercent + branch.percentVat > 0?26:0;
                break;
            case 7:
                return branch.serviceChargePercent>0 && branch.percentVat>0?26:0;
            default:
                break;
        }
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:tbvData])
    {
        if (section == 0)
        {
            return 8;
        }
        else if(section == 1)
        {
            float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
            if(sumSpecialPrice == 0)
            {
                return CGFLOAT_MIN;
            }
        }
        else if(section == 2)
        {
            float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
            if(sumSpecialPrice == 0)
            {
                return CGFLOAT_MIN;
            }
        }
        return tableView.sectionHeaderHeight;
    }
    else
    {
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    if([tableView isEqual:tbvData])
    {
        if(indexPath.section == 2)
        {
            cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if(section == 0 && item == 0)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil                                                            preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"QR code"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                  {
                                      [self performSegueWithIdentifier:@"segQRCodeScanTable" sender:self];
                                  }];
        
        [alert addAction:action1];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:[Language getText:@"ค้นหาเบอร์โต๊ะ"]
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                  {
                                      [self performSegueWithIdentifier:@"segCustomerTableSearch" sender:self];
                                  }];
        
        [alert addAction:action2];
        
        
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:[Language getText:@"ยกเลิก"]
                                                          style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                  {
                                  }];
        
        [alert addAction:action3];
        
        
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            CustomTableViewCellLabelLabel *cell = [tableView cellForRowAtIndexPath:indexPath];            
            UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
            popPresenter.sourceView = cell.lblValue;
            popPresenter.sourceRect = cell.lblValue.bounds;
        }
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
        UIColor *color = cSystem1;
        NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"QR code" attributes:attribute];
        
        UILabel *label = [[action1 valueForKey:@"__representer"] valueForKey:@"label"];
        label.attributedText = attrString;
        
        
        
        UIFont *font2 = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
        UIColor *color2 = cSystem1;
        NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
        NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"ค้นหาเบอร์โต๊ะ"] attributes:attribute2];
        
        UILabel *label2 = [[action2 valueForKey:@"__representer"] valueForKey:@"label"];
        label2.attributedText = attrString2;
        
        
        UIFont *font3 = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
        UIColor *color3 = cSystem4;
        NSDictionary *attribute3 = @{NSForegroundColorAttributeName:color3 ,NSFontAttributeName: font3};
        NSMutableAttributedString *attrString3 = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"ยกเลิก"] attributes:attribute3];
        
        UILabel *label3 = [[action3 valueForKey:@"__representer"] valueForKey:@"label"];
        label3.attributedText = attrString3;
    }
    else if(section == 1 && item == 1)
    {
        if(_creditCard.primaryCard)
        {
            [self performSegueWithIdentifier:@"segSelectPaymentMethod" sender:self];
        }
    }
    else if(section == 1 && item == 2)
    {
        UserAccount *userAccount = [UserAccount getCurrentUserAccount];
        NSMutableDictionary *dicCreditCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"creditCard"] mutableCopy];
        NSMutableArray *creditCardList;
        if(!dicCreditCard)
        {
            dicCreditCard = [[NSMutableDictionary alloc]init];
            creditCardList = [[NSMutableArray alloc]init];
        }
        else
        {
            creditCardList = [dicCreditCard objectForKey:userAccount.username];
            creditCardList = [creditCardList mutableCopy];
            if(!creditCardList)
            {
                creditCardList = [[NSMutableArray alloc]init];
            }
        }
        
        [CreditCard clearPrimaryCard:_creditCard creditCardList:creditCardList];
        [self performSegueWithIdentifier:@"segSelectPaymentMethod" sender:self];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvTotal])
    {
        CustomTableViewHeaderFooterButton *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierHeaderFooterButton];
        
        NSInteger showBuffetButton = 1;
        NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
        for(OrderTaking *item in orderTakingList)
        {
            Menu *menu = [Menu getMenu:item.menuID branchID:item.branchID];
            if(menu.alacarteMenu == 1 || item.specialPrice > 0)
            {
                showBuffetButton = 0;
                break;
            }
        }
        

        if(showBuffetButton)
        {
            [footerView.btnValue setTitle:[Language getText:@"สั่งบุฟเฟ่ต์"] forState:UIControlStateNormal];
        }
        else
        {
            [footerView.btnValue setTitle:[Language getText:@"ชำระเงิน"] forState:UIControlStateNormal];
        }
        
        _btnPay = footerView.btnValue;
        [footerView.btnValue addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        return footerView;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvTotal])
    {
        float height = 44;
        return height;
    }
    return 0;
}

- (IBAction)addRemoveMenu:(id)sender
{
    VoucherCode *voucherCode = [[VoucherCode alloc]init];
    voucherCode.code = _selectedVoucherCode;
    [VoucherCode setCurrentVoucherCode:voucherCode];
    addRemoveMenu = 1;
    [self performSegueWithIdentifier:@"segUnwindToMainTabBar" sender:self];
}

- (void)pay:(id)sender
{
    
    //validate
    [self.view endEditing:YES];
    
    float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
    if(sumSpecialPrice == 0)
    {
        UIButton *btnPay = (UIButton *)sender;
        btnPay.enabled = NO;
        [self loadWaitingView];
        
        
        UserAccount *userAccount = [UserAccount getCurrentUserAccount];
        Receipt *receipt = [[Receipt alloc]initWithBranchID:branch.branchID customerTableID:customerTable.customerTableID memberID:userAccount.userAccountID servingPerson:0 customerType:4 openTableDate:[Utility currentDateTime] totalAmount:_totalAmount cashAmount:0 cashReceive:0 creditCardType:[self getCreditCardType:_creditCard.creditCardNo] creditCardNo:_creditCard.creditCardNo creditCardAmount:_netTotal transferDate:[Utility notIdentifiedDate] transferAmount:0 remark:_remark specialPriceDiscount:_specialPriceDiscount discountType:0 discountAmount:0 discountValue:_discountValue discountReason:@"" serviceChargePercent:branch.serviceChargePercent serviceChargeValue:_serviceChargeValue priceIncludeVat:branch.priceIncludeVat vatPercent:branch.percentVat vatValue:_vatValue beforeVat:_beforeVat status:2 statusRoute:@"" receiptNoID:@"" receiptNoTaxID:@"" receiptDate:[Utility currentDateTime] sendToKitchenDate:[Utility notIdentifiedDate] deliveredDate:[Utility notIdentifiedDate] mergeReceiptID:0 hasBuffetMenu:0 timeToOrder:0 buffetEnded:0 buffetEndedDate:[Utility notIdentifiedDate] buffetReceiptID:buffetReceipt.receiptID voucherCode:_selectedVoucherCode shopDiscount:0 jummumDiscount:0 transactionFeeValue:0 jummumPayValue:0];
        
                            
        
        
        
        //paymentmethod,discount,receiptno
        NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
        NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingList:orderTakingList];
        orderTakingList = [OrderTaking updateStatus:0 orderTakingList:orderTakingList];
        
        
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel insertItemsJson:dbBuffetOrder withData:@[receipt,orderTakingList,orderNoteList] actionScreen:@"buffet order insert"];
    }
    else
    {
        //customerTable
        if(!customerTable)
        {
            [self blinkAlertMsg:[Language getText:@"กรุณาระบุเลขโต๊ะ"]];
            return;
        }
        
        
        
        //credit card
        if([Utility isStringEmpty:_creditCard.firstName])
        {
            [self blinkAlertMsg:[Language getText:@"กรุณาระบุชื่อ"]];
            UIView *vwInvalid = [self.view viewWithTag:11];
            vwInvalid.backgroundColor = cSystem1;
            return;
        }
        if([Utility isStringEmpty:_creditCard.lastName])
        {
            [self blinkAlertMsg:[Language getText:@"กรุณาระบุนามสกุล"]];
            UIView *vwInvalid = [self.view viewWithTag:12];
            vwInvalid.backgroundColor = cSystem1;
            return;
        }
        if(![OMSCardNumber validate:_creditCard.creditCardNo])
        {
            [self blinkAlertMsg:[Language getText:@"หมายเลขบัตรเครดิต/เดบิตไม่ถูกต้อง"]];
            UIView *vwInvalid = [self.view viewWithTag:13];
            vwInvalid.backgroundColor = cSystem1;
            return;
        }
        if(_creditCard.month < 1 || _creditCard.month > 12)
        {
            [self blinkAlertMsg:[Language getText:@"เดือนไม่ถูกต้อง กรุณาใส่เดือนระหว่าง 01 ถึง 12"]];
            UIView *vwInvalid = [self.view viewWithTag:14];
            vwInvalid.backgroundColor = cSystem1;
            return;
        }
        if([[NSString stringWithFormat:@"%ld",_creditCard.year] length] < 4)
        {
            [self blinkAlertMsg:[Language getText:@"ปีไม่ถูกต้อง กรุณาใส่ปีจำนวน 4 หลัก"]];
            UIView *vwInvalid = [self.view viewWithTag:15];
            vwInvalid.backgroundColor = cSystem1;
            return;
        }
        NSString *strExpiredDate = [NSString stringWithFormat:@"%04ld%02ld01 00:00:00",_creditCard.year,_creditCard.month];
        NSDate *expireDate = [Utility stringToDate:strExpiredDate fromFormat:@"yyyyMMdd HH:mm:ss"];
        if(![Utility isExpiredDateValid:expireDate])
        {
            [self blinkAlertMsg:[Language getText:@"บัตรใบนี้หมดอายุแล้ว"]];
            UIView *vwInvalid = [self.view viewWithTag:15];
            vwInvalid.backgroundColor = cSystem1;
            return;
        }
        if([_creditCard.ccv length] < 3)
        {
            [self blinkAlertMsg:[Language getText:@"กรุณาใส่รหัสความปลอดภัย 3 หลัก"]];
            UIView *vwInvalid = [self.view viewWithTag:16];
            vwInvalid.backgroundColor = cSystem1;
            return;
        }
        
        
        UIButton *btnPay = (UIButton *)sender;
        btnPay.enabled = NO;
        [self loadWaitingView];
        
        
        
        NSString *strCreditCardName = [NSString stringWithFormat:@"%@ %@",_creditCard.firstName,_creditCard.lastName];
        OMSTokenRequest *request = [[OMSTokenRequest alloc]initWithName:strCreditCardName number:_creditCard.creditCardNo expirationMonth:_creditCard.month expirationYear:_creditCard.year securityCode:_creditCard.ccv city:@"" postalCode:@""];
        
        
        
        NSString *publicKey = [Setting getSettingValueWithKeyName:@"PublicKey"];
        OMSSDKClient *client = [[OMSSDKClient alloc]initWithPublicKey:publicKey];
        [client sendRequest:request callback:^(OMSToken * _Nullable token, NSError * _Nullable error) {
            //
            if(!error)
            {
                NSLog(@"%@",[token tokenId]);
                
                
                
                
                //update nsuserdefault _creditcard
                if(_creditCard.saveCard)
                {
                    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
                    NSMutableDictionary *dicCreditCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"creditCard"] mutableCopy];
                    NSMutableArray *creditCardList;
                    if(!dicCreditCard)
                    {
                        dicCreditCard = [[NSMutableDictionary alloc]init];
                        creditCardList = [[NSMutableArray alloc]init];
                    }
                    else
                    {
                        creditCardList = [dicCreditCard objectForKey:userAccount.username];
                        creditCardList = [creditCardList mutableCopy];
                        if(!creditCardList)
                        {
                            creditCardList = [[NSMutableArray alloc]init];
                        }
                    }
                    
                    [CreditCard updatePrimaryCard:_creditCard creditCardList:creditCardList];
                }
                
                
                
                
                UserAccount *userAccount = [UserAccount getCurrentUserAccount];
                Receipt *receipt = [[Receipt alloc]initWithBranchID:branch.branchID customerTableID:customerTable.customerTableID memberID:userAccount.userAccountID servingPerson:0 customerType:4 openTableDate:[Utility currentDateTime] totalAmount:_totalAmount cashAmount:0 cashReceive:0 creditCardType:[self getCreditCardType:_creditCard.creditCardNo] creditCardNo:_creditCard.creditCardNo creditCardAmount:_netTotal transferDate:[Utility notIdentifiedDate] transferAmount:0 remark:_remark specialPriceDiscount:_specialPriceDiscount discountType:0 discountAmount:0 discountValue:_discountValue discountReason:@"" serviceChargePercent:branch.serviceChargePercent serviceChargeValue:_serviceChargeValue priceIncludeVat:branch.priceIncludeVat vatPercent:branch.percentVat vatValue:_vatValue beforeVat:_beforeVat status:2 statusRoute:@"" receiptNoID:@"" receiptNoTaxID:@"" receiptDate:[Utility currentDateTime] sendToKitchenDate:[Utility notIdentifiedDate] deliveredDate:[Utility notIdentifiedDate] mergeReceiptID:0 hasBuffetMenu:0 timeToOrder:0 buffetEnded:0 buffetEndedDate:[Utility notIdentifiedDate] buffetReceiptID:buffetReceipt.receiptID voucherCode:_selectedVoucherCode shopDiscount:0 jummumDiscount:0 transactionFeeValue:0 jummumPayValue:0];
                
                
                
                //paymentmethod,discount,receiptno
                NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
                NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingList:orderTakingList];
                orderTakingList = [OrderTaking updateStatus:0 orderTakingList:orderTakingList];
                
                
                
                _selectedVoucherCode = _selectedVoucherCode?_selectedVoucherCode:@"";
                self.homeModel = [[HomeModel alloc]init];
                self.homeModel.delegate = self;
                [self.homeModel insertItemsJson:dbOmiseCheckOut withData:@[[token tokenId],@(_netTotal*100),receipt,orderTakingList,orderNoteList,_selectedVoucherCode] actionScreen:@"call omise checkout at server"];
            }
            else
            {
                [self removeWaitingView];
                btnPay.enabled = YES;
//                NSString *message = [Language getText:@"การจ่ายด้วยบัตรเครดิต/เดบิตขัดข้อง กรุณาติดต่อเจ้าหน้าที่ที่เกี่ยวข้อง"];
                NSString *message = [Language getText:@"กรุณาตรวจสอบข้อมูลบัตรเครดิต/เดบิต อีกครั้งค่ะ"];
                [self showAlert:@"" message:message];
            }
        }];
    }
}

-(void)swtSaveDidChange:(id)sender
{
    UISwitch *swtSave = sender;
    _creditCard.saveCard = swtSave.on;
}

-(void)txtCardNoDidChange:(id)sender
{
    UITextField *txtCardNo = sender;
    NSInteger cardBrand = [OMSCardNumber brandForPan:txtCardNo.text];
    UIImageView *imgCreditCardBrand = [self.view viewWithTag:21];
    switch (cardBrand)
    {
        case OMSCardBrandJCB:
        {
            imgCreditCardBrand.hidden = NO;
            imgCreditCardBrand.image = [UIImage imageNamed:@"jcb.png"];
        }
            break;
        case OMSCardBrandAMEX:
        {
            imgCreditCardBrand.hidden = NO;
            imgCreditCardBrand.image = [UIImage imageNamed:@"americanExpress.png"];
        }
            break;
        case OMSCardBrandVisa:
        {
            imgCreditCardBrand.hidden = NO;
            imgCreditCardBrand.image = [UIImage imageNamed:@"visa.png"];
        }
            break;
        case OMSCardBrandMasterCard:
        {
            imgCreditCardBrand.hidden = NO;
            imgCreditCardBrand.image = [UIImage imageNamed:@"masterCard.png"];
        }
            break;
        default:
        {
            imgCreditCardBrand.hidden = YES;
        }
            break;
    }
    
    txtCardNo.text = [OMSCardNumber format:txtCardNo.text];
}

-(NSInteger)getCreditCardType:(NSString *)creditCardNo
{
    NSInteger creditCardType = 0;
    NSInteger cardBrand = [OMSCardNumber brandForPan:creditCardNo];
    switch (cardBrand)
    {
        case OMSCardBrandJCB:
        {
            creditCardType = 2;
        }
            break;
        case OMSCardBrandAMEX:
        {
            creditCardType = 1;
        }
            break;
        case OMSCardBrandVisa:
        {
            creditCardType = 5;
        }
            break;
        case OMSCardBrandMasterCard:
        {
            creditCardType = 3;
        }
            break;
        default:
        {
            creditCardType = 0;
        }
            break;
    }
    return creditCardType;
}

-(void)txtMonthDidChange:(id)sender
{
    UITextField *txtMonth = sender;
    if([txtMonth.text length] == 2)
    {
        UITextField *txtYear = [self.view viewWithTag:5];
        [txtYear becomeFirstResponder];
    }
}

-(void)txtYearDidChange:(id)sender
{
    UITextField *txtYear = sender;
    if([txtYear.text length] == 4)
    {
        UITextField *txtCCV = [self.view viewWithTag:6];
        [txtCCV becomeFirstResponder];
    }
}

-(void)itemsInsertedWithReturnData:(NSArray *)items
{
    if([items count] == 1)
    {
        [self removeWaitingView];
        _btnPay.enabled = YES;
        NSMutableArray *messageList = items[0];
        Message *message = messageList[0];
        [self showAlert:@"" message:message.text];
    }
    else
    {
        [self removeWaitingView];
        [OrderTaking removeCurrentOrderTakingList];
        [CreditCard removeCurrentCreditCard];
        [VoucherCode removeCurrentVoucherCode];
        [SaveReceipt removeCurrentSaveReceipt];
        
        
        [Utility addToSharedDataList:items];
        NSMutableArray *receiptList = items[0];
        Receipt *receipt = receiptList[0];
        _receipt = receipt;
        if([items  count] == 4)
        {
            NSMutableArray *luckyDrawTicketList = items[3];
            _numberOfGift = [luckyDrawTicketList count];
        }
        [self performSegueWithIdentifier:@"segPaymentComplete" sender:self];
    }
}

-(void)alertMsg:(NSString *)msg
{
    [self removeWaitingView];
    
    [self showAlert:@"" message:msg];
}

-(void)addCreditCard:(id)sender
{
    [self performSegueWithIdentifier:@"segSelectPaymentMethod" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segSelectPaymentMethod"])
    {
        SelectPaymentMethodViewController *vc = segue.destinationViewController;
        vc.creditCard = _creditCard;
    }
    else if([[segue identifier] isEqualToString:@"segQRCodeScanTable"])
    {
        QRCodeScanTableViewController *vc = segue.destinationViewController;
        vc.fromCreditCardAndOrderSummaryMenu = 1;
        vc.customerTable = customerTable;
    }
    else if([[segue identifier] isEqualToString:@"segCustomerTableSearch"])
    {
        CustomerTableSearchViewController *vc = segue.destinationViewController;
        vc.fromCreditCardAndOrderSummaryMenu = 1;
        vc.branch = branch;
        vc.customerTable = customerTable;
    }
    else if([[segue identifier] isEqualToString:@"segPaymentComplete"])
    {
        PaymentCompleteViewController *vc = segue.destinationViewController;
        vc.receipt = _receipt;
        vc.numberOfGift = _numberOfGift;
    }
    else if([[segue identifier] isEqualToString:@"segVoucherCodeList"])
    {
        VoucherCodeListViewController *vc = segue.destinationViewController;
        vc.promotionList = _promotionList;
        vc.rewardRedemptionList = _rewardRedemptionList;
    }
    else if([[segue identifier] isEqualToString:@"segShareMenuToOrder"])
    {
        ShareMenuToOrderViewController *vc = segue.destinationViewController;
        UserAccount *userAccount = [UserAccount getCurrentUserAccount];
        SaveReceipt *saveReceipt = [[SaveReceipt alloc]initWithBranchID:branch.branchID customerTableID:customerTable.customerTableID memberID:userAccount.userAccountID remark:_remark status:0 buffetReceiptID:buffetReceipt.receiptID voucherCode:_selectedVoucherCode];
        NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
        NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingList:orderTakingList];
        orderTakingList = [OrderTaking updateStatus:0 orderTakingList:orderTakingList];
        
        
        vc.saveReceipt = saveReceipt;
        vc.saveOrderTakingList = [SaveOrderTaking createSaveOrderTakingList:orderTakingList];
        vc.saveOrderNoteList = [SaveOrderNote createSaveOrderNoteList:orderNoteList];
    }
}

-(void)confirmVoucherCode
{
    [self confirmVoucherCode:_selectedVoucherCode];
}

- (void)confirmVoucherCode:(NSString *)voucherCode
{
    if([Utility isStringEmpty:voucherCode])
    {
        [self blinkAlertMsg:[Language getText:@"กรุณาระบุคูปองส่วนลด"]];
        return;
    }
    //เช็คว่า voucher valid มั๊ย
    [self loadingOverlayView];
    float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
    sumSpecialPrice = roundf(sumSpecialPrice*100)/100;
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItemsJson:dbPromotion withData:@[voucherCode,userAccount,branch,@(sumSpecialPrice),[OrderTaking getCurrentOrderTakingList]]];

}

- (void)chooseVoucherCode:(id)sender
{
    [self performSegueWithIdentifier:@"segVoucherCodeList" sender:self];
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbPromotion)
    {
        [self removeOverlayViews];
        NSMutableArray *promotionList = items[0];
        Promotion *promotion = promotionList[0];;
        if(![Utility isStringEmpty:promotion.error])
        {
            [self blinkAlertMsg:promotion.error];
            return;
        }
        

        _discountValue = promotion.discountValue;
        float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
        
        
        //voucher code textbox cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
        CustomTableViewCellVoucherCodeExist *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
        

        //hide voucher textbox
        cell.txtVoucherCode.hidden = YES;
        cell.btnConfirm.hidden = YES;
        cell.btnChooseVoucherCode.hidden = YES;
        
        
        //show use voucher code
        voucherView.hidden = NO;
        CGRect frame = voucherView.frame;
        frame.origin.x = 0;
        frame.origin.y = cell.frame.size.height/2-13;
        frame.size.width = self.view.frame.size.width;
        frame.size.height = 26;
        voucherView.frame = frame;
        [cell addSubview:voucherView];
        
        
        
        //voucher code
        voucherView.lblVoucherCode.text = [NSString stringWithFormat:[Language getText:@"คูปองส่วนลด %@"],_selectedVoucherCode];
        [voucherView.lblVoucherCode sizeToFit];
        voucherView.lblVoucherCodeWidthConstant.constant = voucherView.lblVoucherCode.frame.size.width;
        
        
        //discount value
        voucherView.lblDiscountAmount.text = [Utility formatDecimal:_discountValue withMinFraction:2 andMaxFraction:2];
        voucherView.lblDiscountAmount.text = [Utility addPrefixBahtSymbol:voucherView.lblDiscountAmount.text];
        voucherView.lblDiscountAmount.text = [NSString stringWithFormat:@"-%@",voucherView.lblDiscountAmount.text];
        
        
        
        
        //after discount, service charge, vat ,net total
        //after discount
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
            CustomTableViewCellTotal *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
            
            float afterDiscount = sumSpecialPrice-_discountValue;
            NSString *strAfterDiscount = [Utility formatDecimal:afterDiscount withMinFraction:2 andMaxFraction:2];
            strAfterDiscount = [Utility addPrefixBahtSymbol:strAfterDiscount];
            cell.lblAmount.text = strAfterDiscount;
        }
        
        
        {
            //service charge
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:4 inSection:0];
            CustomTableViewCellTotal *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
            
            float afterDiscount = sumSpecialPrice-_discountValue;
            float serviceChargeValue;
            if(branch.priceIncludeVat)
            {
                afterDiscount = afterDiscount / ((branch.percentVat+100)*0.01);
                serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
            }
            else
            {
                serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
            }
            
            serviceChargeValue = roundf(serviceChargeValue * 100)/100;
            serviceChargeValue = branch.serviceChargePercent > 0?serviceChargeValue:0;
            NSString *strTotal = [Utility formatDecimal:serviceChargeValue withMinFraction:2 andMaxFraction:2];
            strTotal = [Utility addPrefixBahtSymbol:strTotal];
            cell.lblAmount.text = strTotal;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblAmount.textColor = cSystem4;
        }
        {
            //vat
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:5 inSection:0];
            CustomTableViewCellTotal *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
            
            float afterDiscount = sumSpecialPrice-_discountValue;
            float serviceChargeValue;
            float vatAmount;
            if(branch.priceIncludeVat)
            {
                afterDiscount = afterDiscount / ((branch.percentVat+100)*0.01);
            }
            serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
            serviceChargeValue = roundf(serviceChargeValue * 100)/100;
            vatAmount = (afterDiscount+serviceChargeValue)*branch.percentVat/100;
            vatAmount = roundf(vatAmount*100)/100;
            NSString *strAmount = [Utility formatDecimal:vatAmount withMinFraction:2 andMaxFraction:2];
            strAmount = [Utility addPrefixBahtSymbol:strAmount];
            cell.lblAmount.text = strAmount;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblAmount.textColor = cSystem4;
        }
        {
            //net total amount
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:6 inSection:0];
            CustomTableViewCellTotal *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
            
            float afterDiscount = sumSpecialPrice-_discountValue;
            float serviceChargeValue;
            float vatAmount;
            if(branch.priceIncludeVat)
            {
                afterDiscount = afterDiscount / ((branch.percentVat+100)*0.01);
            }
            serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
            serviceChargeValue = roundf(serviceChargeValue * 100)/100;
            vatAmount = (afterDiscount+serviceChargeValue)*branch.percentVat/100;
            vatAmount = roundf(vatAmount*100)/100;
            _vatValue = vatAmount;
            _serviceChargeValue = serviceChargeValue;
            float netTotalAmount = afterDiscount+serviceChargeValue+vatAmount;
            netTotalAmount = roundf(netTotalAmount*100)/100;
            NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
            strAmount = [Utility addPrefixBahtSymbol:strAmount];
            cell.lblAmount.text = strAmount;
            _netTotal = netTotalAmount;
        }
        {
            //beforeVat
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:7 inSection:0];
            CustomTableViewCellTotal *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
            
            float afterDiscount = sumSpecialPrice-_discountValue;
            float serviceChargeValue;
            float beforeVat;
            if(branch.priceIncludeVat)
            {
                afterDiscount = afterDiscount / ((branch.percentVat+100)*0.01);
            }
            serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
            serviceChargeValue = roundf(serviceChargeValue * 100)/100;
            beforeVat = afterDiscount+serviceChargeValue;
            beforeVat = roundf(beforeVat*100)/100;
            NSString *strAmount = [Utility formatDecimal:beforeVat withMinFraction:2 andMaxFraction:2];
            strAmount = [Utility addPrefixBahtSymbol:strAmount];
            cell.lblAmount.text = strAmount;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblAmount.textColor = cSystem4;
        }
    }
    else if(homeModel.propCurrentDB == dbPromotionAndRewardRedemption)
    {
        [self removeOverlayViews];
        _promotionList = [items[0] mutableCopy];
        _rewardRedemptionList = [items[1] mutableCopy];
        [tbvTotal reloadData];
        
        
        if(fromRewardRedemption || fromLuckyDraw)
        {
            _selectedVoucherCode = rewardRedemption.voucherCode;
            [self confirmVoucherCode:_selectedVoucherCode];
        }
        else if(fromHotDealDetail)
        {
            _selectedVoucherCode = promotion.voucherCode;
            [self confirmVoucherCode:_selectedVoucherCode];
        }
        else
        {
            VoucherCode *voucherCode = [VoucherCode getCurrentVoucherCode];
            _selectedVoucherCode = voucherCode.code?voucherCode.code:@"";
            if([Utility isStringEmpty:_selectedVoucherCode])
            {
                SaveReceipt *saveReceipt = [SaveReceipt getCurrentSaveReceipt];
                _selectedVoucherCode = saveReceipt && ![Utility isStringEmpty:saveReceipt.voucherCode]?saveReceipt.voucherCode:@"";
                _remark = saveReceipt?saveReceipt.remark:@"";
                [SaveReceipt removeCurrentSaveReceipt];
            }
            if(![Utility isStringEmpty:_selectedVoucherCode])
            {
                [self confirmVoucherCode:_selectedVoucherCode];
            }
        }
    }
}

-(void)deleteVoucher:(id)sender
{
    [voucherView removeFromSuperview];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
    CustomTableViewCellVoucherCodeExist *cell = [tbvTotal cellForRowAtIndexPath:indexPath];

    cell.txtVoucherCode.text = @"";
    cell.txtVoucherCode.hidden = NO;
    cell.btnConfirm.hidden = NO;
    cell.btnChooseVoucherCode.hidden = [_promotionList count]+[_rewardRedemptionList count]==0;
    
    _selectedVoucherCode = @"";

    


    //after discount, vat,service charge,net total
    float sumSpecialPrice = [OrderTaking getSumSpecialPrice:_orderTakingList];
    sumSpecialPrice = roundf(sumSpecialPrice*100)/100;
    _discountValue = 0;
    {
        //after discount
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
        CustomTableViewCellTotal *cell = [tbvTotal cellForRowAtIndexPath:indexPath];

        float afterDiscount = sumSpecialPrice-_discountValue;
        NSString *strAfterDiscount = [Utility formatDecimal:afterDiscount withMinFraction:2 andMaxFraction:2];
        strAfterDiscount = [Utility addPrefixBahtSymbol:strAfterDiscount];
        cell.lblAmount.text = strAfterDiscount;
    }
    {
        //service charge
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:4 inSection:0];
        CustomTableViewCellTotal *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
        
        float afterDiscount = sumSpecialPrice-_discountValue;
        float serviceChargeValue;
        if(branch.priceIncludeVat)
        {
            afterDiscount = afterDiscount / ((branch.percentVat+100)*0.01);
            serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
        }
        else
        {
            serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
        }
        
        serviceChargeValue = roundf(serviceChargeValue * 100)/100;
        NSString *strTotal = [Utility formatDecimal:serviceChargeValue withMinFraction:2 andMaxFraction:2];
        strTotal = [Utility addPrefixBahtSymbol:strTotal];
        cell.lblAmount.text = strTotal;
        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
        cell.lblAmount.textColor = cSystem4;
    }
    {
        //vat
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:5 inSection:0];
        CustomTableViewCellTotal *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
        
        float afterDiscount = sumSpecialPrice-_discountValue;
        float serviceChargeValue;
        float vatAmount;
        if(branch.priceIncludeVat)
        {
            afterDiscount = afterDiscount / ((branch.percentVat+100)*0.01);
            serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
            serviceChargeValue = roundf(serviceChargeValue * 100)/100;
            vatAmount = afterDiscount * branch.percentVat * 0.01;
        }
        else
        {
            serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
            serviceChargeValue = roundf(serviceChargeValue * 100)/100;
            vatAmount = (afterDiscount+serviceChargeValue)*branch.percentVat/100;
        }
        
        vatAmount = roundf(vatAmount*100)/100;
        NSString *strAmount = [Utility formatDecimal:vatAmount withMinFraction:2 andMaxFraction:2];
        strAmount = [Utility addPrefixBahtSymbol:strAmount];
        cell.lblAmount.text = strAmount;
        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
        cell.lblAmount.textColor = cSystem4;
    }
    {
        //net total amount
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:6 inSection:0];
        CustomTableViewCellTotal *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
        
        float afterDiscount = sumSpecialPrice-_discountValue;
        float serviceChargeValue;
        float vatAmount;
        if(branch.priceIncludeVat)
        {
            afterDiscount = afterDiscount / ((branch.percentVat+100)*0.01);
            serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
            serviceChargeValue = roundf(serviceChargeValue * 100)/100;
            vatAmount = afterDiscount * branch.percentVat * 0.01;
        }
        else
        {
            serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
            serviceChargeValue = roundf(serviceChargeValue * 100)/100;
            vatAmount = (afterDiscount+serviceChargeValue)*branch.percentVat/100;
        }
        
        vatAmount = roundf(vatAmount*100)/100;
        _vatValue = vatAmount;
        _serviceChargeValue = serviceChargeValue;
        float netTotalAmount = afterDiscount+serviceChargeValue+vatAmount;
        netTotalAmount = roundf(netTotalAmount*100)/100;
        NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
        strAmount = [Utility addPrefixBahtSymbol:strAmount];
        cell.lblAmount.text = strAmount;
        _netTotal = netTotalAmount;
    }
    {
        //beforeVat
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:7 inSection:0];
        CustomTableViewCellTotal *cell = [tbvTotal cellForRowAtIndexPath:indexPath];
    
        float afterDiscount = sumSpecialPrice-_discountValue;
        float serviceChargeValue;
        float beforeVat;
        if(branch.priceIncludeVat)
        {
            afterDiscount = afterDiscount / ((branch.percentVat+100)*0.01);
        }
        serviceChargeValue = branch.serviceChargePercent * afterDiscount * 0.01;
        serviceChargeValue = roundf(serviceChargeValue * 100)/100;
        beforeVat = afterDiscount+serviceChargeValue;
        beforeVat = roundf(beforeVat*100)/100;
        NSString *strAmount = [Utility formatDecimal:beforeVat withMinFraction:2 andMaxFraction:2];
        strAmount = [Utility addPrefixBahtSymbol:strAmount];
        cell.lblAmount.text = strAmount;
        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
        cell.lblAmount.textColor = cSystem4;
    }
}

-(void)txtVoucherCodeChanged:(id)sender
{
    UITextField *txtVoucherCode = sender;
    txtVoucherCode.text = [txtVoucherCode.text uppercaseString];
}

-(void)goToNextResponder:(id)sender
{
    UITextField *textField = [self.view viewWithTag:4];
    [textField becomeFirstResponder];
}

- (IBAction)shareMenuToOrder:(id)sender
{
    [self performSegueWithIdentifier:@"segShareMenuToOrder" sender:self];
}
@end
