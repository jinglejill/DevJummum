//
//  OrderDetailViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 10/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ConfirmDisputeViewController.h"
#import "DisputeFormViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "CommentRatingViewController.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellLabelLabel.h"
#import "CustomTableViewCellButton.h"
#import "CustomTableViewCellDisputeDetail.h"
#import "CustomTableViewCellRating.h"
#import "CustomTableViewCellLabelRemark.h"
#import "Receipt.h"
#import "UserAccount.h"
#import "Branch.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"
#import "Dispute.h"
#import "DisputeReason.h"
#import "Setting.h"
#import "Rating.h"
#import "QuartzCore/QuartzCore.h"


@interface OrderDetailViewController ()
{
    Branch *_receiptBranch;
    NSInteger _fromType;//1=cancel,2=dispute
    float _accumHeight;
    Rating *_rating;
}
@end

@implementation OrderDetailViewController
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierLabelLabel = @"CustomTableViewCellLabelLabel";
static NSString * const reuseIdentifierButton = @"CustomTableViewCellButton";
static NSString * const reuseIdentifierDisputeDetail = @"CustomTableViewCellDisputeDetail";
static NSString * const reuseIdentifierRating = @"CustomTableViewCellRating";
static NSString * const reuseIdentifierLabelRemark = @"CustomTableViewCellLabelRemark";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize tbvRating;
@synthesize receipt;
@synthesize topViewHeight;
@synthesize bottomButtonHeight;
@synthesize tbvRatingHeight;


-(IBAction)unwindToOrderDetail:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isKindOfClass:[ConfirmDisputeViewController class]] || [segue.sourceViewController isKindOfClass:[DisputeFormViewController class]]  || [segue.sourceViewController isKindOfClass:[CommentRatingViewController class]])
    {
        CustomViewController *vc = (CustomViewController *)segue.sourceViewController;
        if(vc.showOrderDetail)
        {
            receipt = vc.selectedReceipt;
            [self reloadTableView];
        }
    }
    
    if([segue.sourceViewController isKindOfClass:[CommentRatingViewController class]])
    {
        [self reloadTableView];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"รายละเอียดการสั่งอาหาร"];
    lblNavTitle.text = title;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    tbvRating.delegate = self;
    tbvRating.dataSource = self;
    tbvRating.scrollEnabled = NO;
    _rating = [Rating getRatingWithReceiptID:receipt.receiptID];
    if(!_rating)
    {
        _rating = [[Rating alloc]initWithReceiptID:receipt.receiptID score:0 comment:@""];
    }
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierButton];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierDisputeDetail bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierDisputeDetail];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierRating bundle:nil];
        [tbvRating registerNib:nib forCellReuseIdentifier:reuseIdentifierRating];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
    }
    
    
    [self.homeModel downloadItems:dbReceiptDisputeRating withData:@(receipt.receiptID)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.homeModel downloadItems:dbReceiptDisputeRating withData:@(receipt.receiptID)];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([tableView isEqual:tbvData])
    {
        return 3;
    }
    else if([tableView isEqual:tbvRating])
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvData])
    {
        if(section == 0)
        {
            return 1;
        }
        else if(section == 1)
        {
            if(receipt.buffetReceiptID)
            {
                return 1+1;//total and remark
            }
            else
            {
                return 7;//remark,total items,discount,after discount,service charge,vat,net total
            }
        }
        else if(section == 2)
        {
            if(receipt.status == 2 || receipt.status == 5 || receipt.status == 6)
            {
                return 2;
            }
            else if(receipt.status == 7 || receipt.status == 8)
            {
                return 1+1;
            }
            else if(receipt.status == 9 || receipt.status == 10 || receipt.status == 11)
            {
                return 1+1;
            }
            else if(receipt.status == 12)//jummum admin edit refund price and request customer to review and confirm if(confirm)status = 13,if not status = 11
            {
                return 1+4;
            }
            else if(receipt.status == 13)//shop review the refund price if(confirm)status = 14, if not status = 11
            {
                return 1+1;
            }
            else if(receipt.status == 14)
            {
                return 1+1;
            }
        }
    }
    else if([tableView isEqual:tbvRating])
    {
        return 1;
    }
    else
    {
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        
        
        return [orderTakingList count];
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
            CustomTableViewCellReceiptSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            //(buffet)
            UIColor *color = cSystem4;
            NSDictionary *attribute = @{NSForegroundColorAttributeName:color};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Order no. #%@",receipt.receiptNoID] attributes:attribute];
            
            
            UIColor *color2 = cSystem2;
            NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@" (Buffet)" attributes:attribute2];
            if(receipt.buffetReceiptID)
            {
                [attrString appendAttributedString:attrString2];
            }
            
            NSString *message = [Language getText:@"ร้าน %@"];
            Branch *branch = [Branch getBranch:receipt.branchID];
            cell.lblReceiptNo.attributedText = attrString;
            cell.lblReceiptDate.text = [Utility dateToString:receipt.modifiedDate toFormat:@"d MMM yy HH:mm"];
            cell.lblBranchName.text = [NSString stringWithFormat:message,branch.name];
            cell.lblBranchName.textColor = cSystem1;
            
            
            
            {
                UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
                [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
            }
            
            
            cell.tbvOrderDetail.scrollEnabled = NO;
            cell.tbvOrderDetail.delegate = self;
            cell.tbvOrderDetail.dataSource = self;
            cell.tbvOrderDetail.tag = receipt.receiptID;
            [cell.tbvOrderDetail reloadData];
            [cell.btnOrderItAgain setTitle:[Language getText:@"สั่งซ้ำ"] forState:UIControlStateNormal];
            [cell.btnOrderItAgain addTarget:self action:@selector(orderItAgain:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnOrderItAgain];
            
            
            return cell;
        }
        else if(section == 1)
        {
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
            Branch *branch = [Branch getBranch:receipt.branchID];
            
            
            if(item == 0)
            {
                CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                if([Utility isStringEmpty:receipt.remark])
                {
                    cell.lblText.attributedText = [self setAttributedString:@"" text:receipt.remark];
                }
                else
                {
                    NSString *message = [Language getText:@"หมายเหตุ: "];
                    cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
                }
                [cell.lblText sizeToFit];
                cell.lblTextHeight.constant = cell.lblText.frame.size.height;
                
                return cell;
                
            }
            else
            {
                switch (item)
                {
                    case 1:
                    {
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *message = [Language getText:@"%ld รายการ"];
                        NSString *strTitle = [NSString stringWithFormat:message,[orderTakingList count]];
                        NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
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
                    case 2:
                    {
                        //discount
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *message = [Language getText:@"คูปองส่วนลด %@"];
                        NSString *strDiscount = [Utility formatDecimal:receipt.discountAmount withMinFraction:0 andMaxFraction:2];
                        strDiscount = ![Utility isStringEmpty:receipt.voucherCode]?[NSString stringWithFormat:message,receipt.voucherCode]:strDiscount;
                        
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.discountValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        strAmount = [NSString stringWithFormat:@"-%@",strAmount];
                        
                        
                        cell.lblTitle.text = strDiscount;
                        cell.lblAmount.text = strAmount;
                        [cell.lblAmount sizeToFit];
                        cell.lblAmountWidth.constant = cell.lblAmount.frame.size.width;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                        cell.lblTitle.textColor = cSystem4;
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                        cell.lblAmount.textColor = cSystem2;
                        cell.hidden = receipt.discountAmount == 0;
                        
                        return cell;
                    }
                        break;
                    case 3:
                    {
                        //after discount
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *strTitle = branch.priceIncludeVat?[Language getText:@"ยอดรวม (รวม Vat)"]:[Language getText:@"ยอดรวม"];
                        NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList]-receipt.discountValue withMinFraction:2 andMaxFraction:2];
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
                        
                        
                        NSString *strServiceChargePercent = [Utility formatDecimal:receipt.serviceChargePercent withMinFraction:0 andMaxFraction:2];
                        strServiceChargePercent = [NSString stringWithFormat:@"Service charge %@%%",strServiceChargePercent];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.serviceChargeValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = strServiceChargePercent;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                        cell.lblAmount.textColor = cSystem4;
                        cell.hidden = branch.serviceChargePercent == 0;
                        
                        
                        return cell;
                    }
                        break;
                    case 5:
                    {
                        //vat
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                        strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
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
                        
                        
                        
                        float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                        NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        cell.lblTitle.text = [Language getText:@"ยอดรวมทั้งสิ้น"];
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                        cell.lblTitle.textColor = cSystem4;
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                        cell.lblAmount.textColor = cSystem1;
                        cell.hidden = branch.serviceChargePercent+branch.percentVat == 0;
                        
                        
                        return cell;
                    }
                        break;
                }
            }
        }
        else if(section == 2)
        {
            if(item == 0)
            {
                CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strStatus = [Receipt getStrStatus:receipt];
                UIColor *color = cSystem2;//[Receipt getStatusColor:receipt];
                
                
                
                UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrStringStatus = [[NSMutableAttributedString alloc] initWithString:strStatus attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color2 = cSystem4;
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrStringStatusLabel = [[NSMutableAttributedString alloc] initWithString:@"Status: " attributes:attribute2];
                
                
                [attrStringStatusLabel appendAttributedString:attrStringStatus];
                cell.lblValue.attributedText = attrStringStatusLabel;
                cell.lblText.text = @"";
                
                
                
                return cell;
            }
            else
            {
                if(receipt.status == 2)
                {
                    CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    NSString *title = [Setting getValue:@"004t" example:@"Cancel order"];
                    NSDate *endDate = [Utility addDay:receipt.receiptDate numberOfDay:7];
                    NSComparisonResult result = [[Utility currentDateTime] compare:endDate];
                    cell.btnValue.hidden = result != NSOrderedAscending;
                    
                    
                    cell.btnValue.backgroundColor = cSystem1;
                    [cell.btnValue setTitle:title forState:UIControlStateNormal];
                    [cell.btnValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                    [cell.btnValue addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
                    [self setButtonDesign:cell.btnValue];
                    
                    
                    return cell;
                }
                else if(receipt.status == 5 || receipt.status == 6)
                {
                    CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    NSString *title = [Setting getValue:@"005t" example:@"Open dispute"];
                    NSDate *endDate = [Utility addDay:receipt.receiptDate numberOfDay:7];
                    NSComparisonResult result = [[Utility currentDateTime] compare:endDate];
                    cell.btnValue.hidden = result != NSOrderedAscending;
                    
                    
                    [cell.btnValue setTitle:title forState:UIControlStateNormal];
                    cell.btnValue.backgroundColor = cSystem1;
                    [cell.btnValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                    [cell.btnValue addTarget:self action:@selector(disputeOrder:) forControlEvents:UIControlEventTouchUpInside];
                    [self setButtonDesign:cell.btnValue];
                    
                    
                    return cell;
                }
                else if(receipt.status == 7)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    NSString *message = [Language getText:@"คุณได้ส่งคำร้องขอยกเลิกบิลนี้  ด้วยเหตุผลด้านล่างนี้ กรุณารอการยืนยันการยกเลิกจากร้านค้า"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    float totalAmount = [Receipt getTotalAmount:receipt];
                    NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    cell.lblReasonDetailHeight.constant = 0;
                    cell.lblReasonDetailTop.constant = 0;
                    
                    
                    
                    NSString *message5 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return cell;
                }
                else if(receipt.status == 8)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Language getText:@"คุณส่ง Open dispute ไปที่ร้านค้าด้วยเหตุผลด้านล่างนี้ กรุณารอการยืนยันจากทางร้านค้าสักครู่"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    NSString *message4 = [Language getText:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message4 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    NSString *message5 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return cell;
                }
                else if(receipt.status == 9)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    NSInteger priorStatusIsTwo = [Receipt getPriorStatus:receipt]==2;
                    NSString *message;
                    if(priorStatusIsTwo)
                    {
                        message = [Language getText:@"ร้านค้าทำเรื่องยกเลิกออเดอร์ให้คุณแล้ว คุณจะได้รับเงินคืนภายใน 48 ชม."];
                    }
                    else//8
                    {
                        message = [Language getText:@"คำร้องขอยกเลิกออเดอร์สำเร็จแล้ว คุณจะได้รับเงินคืน ภายใน 48 ชม."];
                    }
                    
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                    if(!dispute)
                    {
                        dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:3];
                    }
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    float totalAmount = [Receipt getTotalAmount:receipt];
                    NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    cell.lblReasonDetailHeight.constant = 0;
                    cell.lblReasonDetailTop.constant = 0;
                    
                    
                    NSString *message4 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message4 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return cell;
                }
                else if(receipt.status == 10)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    NSInteger priorStatusIsFiveOrSix = [Receipt getPriorStatus:receipt]==5||[Receipt getPriorStatus:receipt]==6;
                    NSString *message;
                    if(priorStatusIsFiveOrSix)
                    {
                        message = [Language getText:@"ร้านค้าทำเรื่องคืนเงินให้คุณแล้ว คุณจะได้รับเงินคืนภายใน 48 ชม."];
                    }
                    else//8
                    {
                        message = [Language getText:@"Open dispute ที่ส่งไป ได้รับการยืนยันแล้ว คุณจะได้รับเงินคืนภายใน 48 ชม."];
                    }
                    
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                    if(!dispute)
                    {
                        dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:4];
                    }
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    NSString *message5 = [Language getText:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message5 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    NSString *message6 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message6 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return cell;
                }
                else if(receipt.status == 11)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    NSString *message = [Language getText:@"Open dispute ที่ส่งไปกำลังดำเนินการอยู่ จะมีเจ้าหน้าที่ติดต่อกลับไปภายใน 24 ชม."];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    NSInteger statusBeforeLast = [Receipt getStateBeforeLast:receipt];
                    if(statusBeforeLast == 8)
                    {
                        NSString *message3 = [Language getText:@"เหตุผล: "];
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                        DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                        cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                        [cell.lblReason sizeToFit];
                        cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                        
                        
                        NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                        NSString *message4 = [Language getText:@"%@ บาท"];
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                        
                        
                        NSString *message5 = [Language getText:@"รายละเอียดเหตุผล: "];
                        cell.lblReasonDetail.attributedText = [self setAttributedString:message5 text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        NSString *message6 = [Language getText:@"เบอร์โทรติดต่อ: "];
                        cell.lblPhoneNo.attributedText = [self setAttributedString:message6 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                        [cell.lblPhoneNo sizeToFit];
                        cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    }
                    else if(statusBeforeLast == 12 || statusBeforeLast == 13)
                    {
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                        cell.lblReasonTop.constant = 0;
                        cell.lblReasonHeight.constant = 0;
                        
                        
                        
                        NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                        
                        
                        NSString *message3 = [Language getText:@"รายละเอียดเหตุผล: "];
                        cell.lblReasonDetail.attributedText = [self setAttributedString:message3 text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        cell.lblPhoneNoTop.constant = 0;
                        cell.lblPhoneNoHeight.constant = 0;
                    }
                    
                    return cell;
                }
                else if(receipt.status == 12)
                {
                    if(item == 1)
                    {
                        CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *message = [Language getText:@"หลังจากคุยกับเจ้าหน้าที่ JUMMUM แล้ว มีการแก้ไขจำนวนเงิน refund ใหม่ ตามด้านล่างนี้ กรุณากด Confirm เพื่อยืนยัน หรือหากต้องการแก้ไขรายการกรุณากด Negotiate"];
                        cell.lblRemark.textColor = cSystem1;
                        cell.lblRemark.text = message;
                        [cell.lblRemark sizeToFit];
                        cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                        
                        
                        
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                        cell.lblReasonTop.constant = 0;
                        cell.lblReasonHeight.constant = 0;
                        
                        
                        
                        NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                        NSString *message4 = [Language getText:@"%@ บาท"];
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                        
                        
                        
                        NSString *message5 = [Language getText:@"เหตุผล: "];
                        cell.lblReasonDetail.attributedText = [self setAttributedString:message5 text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        cell.lblPhoneNoTop.constant = 0;
                        cell.lblPhoneNoHeight.constant = 0;
                        
                        
                        return cell;
                    }
                    else if(item == 2)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Confirm" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem2;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(confirmNegotiate:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        
                        return cell;
                    }
                    else if(item == 3)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Negotiate" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem1;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(negotiate:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        
                        return cell;
                    }
                    else if(item == 4)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:@"Cancel" forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem4_10;
                        [cell.btnValue setTitleColor:cSystem4 forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        
                        return cell;
                    }
                }
                else if(receipt.status == 13)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Language getText:@"Open dispute ที่มีการแก้ไขกำลังดำเนินการอยู่ กรุณารอการยืนยันจากทางร้านค้าสักครู่"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                    cell.lblReasonTop.constant = 0;
                    cell.lblReasonHeight.constant = 0;
                    
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    NSString *message3 = [Language getText:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message3 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    cell.lblPhoneNoTop.constant = 0;
                    cell.lblPhoneNoHeight.constant = 0;
                    
                    return cell;
                }
                else if(receipt.status == 14)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Language getText:@"Open dispute ที่ส่งไป ดำเนินการเสร็จสิ้นแล้ว คุณจะได้รับเงินคืนภายใน 48 ชม."];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                    cell.lblReasonTop.constant = 0;
                    cell.lblReasonHeight.constant = 0;
                    
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    NSString *message3 = [Language getText:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message3 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    cell.lblPhoneNoTop.constant = 0;
                    cell.lblPhoneNoHeight.constant = 0;
                    
                    return cell;
                }
            }
        }
    }
    else if([tableView isEqual:tbvRating])
    {
        CustomTableViewCellRating *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRating];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        Rating *rating = [Rating getRatingWithReceiptID:receipt.receiptID];
        if(rating)
        {
            NSString *title = [Setting getValue:@"090t" example:@"You rated"];
            cell.lblTitle.text = title;
            cell.lblRate.text = [Rating getTextWithScore:_rating.score];
            cell.btnRate1.enabled = NO;
            cell.btnRate2.enabled = NO;
            cell.btnRate3.enabled = NO;
            cell.btnRate4.enabled = NO;
            cell.btnRate5.enabled = NO;
            switch (_rating.score)
            {
                case 1:
                {
                    [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateDisabled];
                    [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateDisabled];
                    [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateDisabled];
                    [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateDisabled];
                }
                    break;
                case 2:
                {
                    [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateDisabled];
                    [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateDisabled];
                    [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateDisabled];
                }
                    break;
                case 3:
                {
                    [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateDisabled];
                    [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateDisabled];
                }
                    break;
                case 4:
                {
                    [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateDisabled];
                }
                    break;
                case 5:
                {
                    [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                    [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateDisabled];
                }
                    break;
                default:
                    break;
            }
            
            if([Utility isStringEmpty:rating.comment])
            {
                NSString *title = [Setting getValue:@"096t" example:@"ADD COMMENT"];
                [cell.btnAction setTitle:title forState:UIControlStateNormal];
                [cell.btnAction removeTarget:self action:@selector(viewComment) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnAction addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                NSString *title = [Setting getValue:@"097t" example:@"VIEW COMMENT"];
                [cell.btnAction setTitle:title forState:UIControlStateNormal];
                [cell.btnAction removeTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnAction addTarget:self action:@selector(viewComment) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            NSDate *endDate = [Utility addDay:receipt.receiptDate numberOfDay:30];
            NSComparisonResult result = [[Utility currentDateTime] compare:endDate];
            tbvRatingHeight.constant = result == NSOrderedAscending?169:0;
            
            
            if(tbvRatingHeight.constant)
            {
                NSString *message = [Setting getValue:@"098m" example:@"Please rate my service"];
                cell.lblTitle.text = message;
                cell.lblRate.text = @"";
                [cell.btnRate1 addTarget:self action:@selector(btnRate1) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnRate2 addTarget:self action:@selector(btnRate2) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnRate3 addTarget:self action:@selector(btnRate3) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnRate4 addTarget:self action:@selector(btnRate4) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnRate5 addTarget:self action:@selector(btnRate5) forControlEvents:UIControlEventTouchUpInside];
                
                
                switch (_rating.score)
                {
                    case 0:
                    {
                        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                    }
                        break;
                    case 1:
                    {
                        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                    }
                        break;
                    case 2:
                    {
                        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                    }
                        break;
                    case 3:
                    {
                        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                    }
                        break;
                    case 4:
                    {
                        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
                    }
                        break;
                    case 5:
                    {
                        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
                    }
                        break;
                    default:
                        break;
                }
                
                NSString *title = [Setting getValue:@"099m" example:@"Submit"];
                [cell.btnAction setTitle:title forState:UIControlStateNormal];
                [cell.btnAction addTarget:self action:@selector(submitRating) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        return  cell;
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        
        if(item < [orderTakingList count])
        {
            CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            OrderTaking *orderTaking = orderTakingList[item];
            Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
            cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
            
            
            //menu
            if(orderTaking.takeAway)
            {
                NSString *message = [Language getText:@"ใส่ห่อ"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
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
                NSString *message = [Language getText:@"ไม่ใส่"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSString *message = [Language getText:@"เพิ่ม"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
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
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    NSInteger section = indexPath.section;
    if([tableView isEqual:tbvData])
    {
        if(section == 0)
        {
            //load order มาโชว์
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
            orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
            float sumHeight = 0;
            for(int i=0; i<[orderTakingList count]; i++)
            {
                
                
                CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                OrderTaking *orderTaking = orderTakingList[i];
                Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
                cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
                
                
                //menu
                if(orderTaking.takeAway)
                {
                    NSString *message = [Language getText:@"ใส่ห่อ"];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
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
                    NSString *message = [Language getText:@"ไม่ใส่"];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSString *message = [Language getText:@"เพิ่ม"];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
                    
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
                sumHeight += height;
            }
            
            return sumHeight+83;
        }
        else if(section == 1)
        {
            if(item == 0)
            {
                //remarkHeight
                
                CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
                if([Utility isStringEmpty:receipt.remark])
                {
                    cell.lblText.attributedText = [self setAttributedString:@"" text:receipt.remark];
                }
                else
                {
                    NSString *message = [Language getText:@"หมายเหตุ: "];
                    cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
                }
                [cell.lblText sizeToFit];
                cell.lblTextHeight.constant = cell.lblText.frame.size.height;
                
                cell.lblTextHeight.constant = cell.lblTextHeight.constant<18?18:cell.lblTextHeight.constant;
                float remarkHeight = [Utility isStringEmpty:receipt.remark]?0:4+cell.lblTextHeight.constant+4;
                
                return remarkHeight;
            }
            else
            {
                Branch *branch = [Branch getBranch:receipt.branchID];
                switch (item)
                {
                    case 0:
                        return 26;
                        break;
                    case 1:
                        return 26;
                        break;
                    case 2:
                        return receipt.discountAmount > 0?26:0;
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
                    default:
                        break;
                }
                return 26;
            }
        }
        else if(section == 2)
        {
            if(item == 0)
            {
                return 34;
            }
            else if(item == 1)
            {
                if(receipt.status == 2 || receipt.status == 5 || receipt.status == 6)
                {
                    return 44;
                }
                else if(receipt.status == 7)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Language getText:@"คุณได้ส่งคำร้องขอยกเลิกบิลนี้  ด้วยเหตุผลด้านล่างนี้ กรุณารอการยืนยันการยกเลิกจากร้านค้า"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    float totalAmount = [Receipt getTotalAmount:receipt];
                    NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    cell.lblReasonDetailHeight.constant = 0;
                    cell.lblReasonDetailTop.constant = 0;
                    
                    
                    NSString *message5 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                }
                else if(receipt.status == 8)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Language getText:@"คุณส่ง Open dispute ไปที่ร้านค้าด้วยเหตุผลด้านล่างนี้ กรุณารอการยืนยันจากทางร้านค้าสักครู่"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    NSString *message5 = [Language getText:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message5 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    NSString *message6 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message6 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                }
                else if(receipt.status == 9)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    NSInteger priorStatusIsTwo = [Receipt getPriorStatus:receipt]==2;
                    NSString *message;
                    if(priorStatusIsTwo)
                    {
                        message = [Language getText:@"ร้านค้ายกเลิกออเดอร์ให้คุณแล้ว คุณจะได้รับเงินคืนภายใน 48 ชม."];
                    }
                    else//8
                    {
                        message = [Language getText:@"คำร้องขอยกเลิกออเดอร์สำเร็จแล้ว คุณจะได้รับเงินคืนภายใน 48 ชม."];
                    }
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                    if(!dispute)
                    {
                        dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:3];
                    }
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    float totalAmount = [Receipt getTotalAmount:receipt];
                    NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    cell.lblReasonDetailHeight.constant = 0;
                    cell.lblReasonDetailTop.constant = 0;
                    
                    
                    NSString *message5 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                }
                else if(receipt.status == 10)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSInteger priorStatusIsFiveOrSix = [Receipt getPriorStatus:receipt]==5||[Receipt getPriorStatus:receipt]==6;
                    NSString *message;
                    if(priorStatusIsFiveOrSix)
                    {
                        message = [Language getText:@"ร้านค้าทำเรื่องคืนเงินให้คุณแล้ว คุณจะได้รับเงินคืนภายใน 48 ชม."];
                    }
                    else//8
                    {
                        message = [Language getText:@"Open dispute ที่ส่งไป ได้รับการยืนยันแล้ว คุณจะได้รับเงินคืนภายใน 48 ชม."];
                    }
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                    if(!dispute)
                    {
                        dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:4];
                    }
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    
                    NSString *message5 = [Language getText:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message5 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    NSString *message6 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message6 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                }
                else if(receipt.status == 11)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Language getText:@"Open dispute ที่ส่งไปกำลังดำเนินการอยู่ จะมีเจ้าหน้าที่ติดต่อกลับไปภายใน 24 ชม."];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    NSString *message5 = [Language getText:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message5 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    NSString *message6 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message6 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                }
                else if(receipt.status == 12)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Language getText:@"หลังจากคุยกับเจ้าหน้าที่ JUMMUM แล้ว มีการแก้ไขจำนวนเงิน refund ใหม่ ตามด้านล่างนี้ กรุณากด Confirm เพื่อยืนยัน หรือหากต้องการแก้ไขรายการกรุณากด Negotiate"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                    cell.lblReasonTop.constant = 0;
                    cell.lblReasonHeight.constant = 0;
                    
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    NSString *message5 = [Language getText:@"เหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message5 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    cell.lblPhoneNoTop.constant = 0;
                    cell.lblPhoneNoHeight.constant = 0;
                    
                    return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                }
                else if(receipt.status == 13)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Language getText:@"Open dispute ที่มีการแก้ไขกำลังดำเนินการอยู่ กรุณารอการยืนยันจากทางร้านค้าสักครู่"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    
                    NSString *message5 = [Language getText:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message5 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    NSString *message6 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message6 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    
                    return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                }
                else if(receipt.status == 14)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Language getText:@"Open dispute ที่ส่งไป ดำเนินการเสร็จสิ้นแล้ว คุณจะได้รับเงินคืนภายใน 48 ชม."];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    NSString *message3 = [Language getText:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message3 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    NSString *message2 = [Language getText:@"จำนวนเงินที่ขอคืน: "];
                    NSString *message4 = [Language getText:@"%@ บาท"];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:message4,strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    NSString *message5 = [Language getText:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message5 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    NSString *message6 = [Language getText:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message6 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                }
            }
            else
            {
                return 44;
            }
        }
    }
    else if([tableView isEqual:tbvRating])
    {
        return 169;
    }
    else
    {
        //load order มาโชว์
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        if(indexPath.item < [orderTakingList count])
        {
            CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            OrderTaking *orderTaking = orderTakingList[indexPath.item];
            Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
            cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
            
            
            //menu
            if(orderTaking.takeAway)
            {
                NSString *message = [Language getText:@"ใส่ห่อ"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
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
                NSString *message = [Language getText:@"ไม่ใส่"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSString *message = [Language getText:@"เพิ่ม"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
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
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    
    cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
    if([tableView isEqual:tbvData])
    {
        if([Utility isStringEmpty:receipt.remark] && indexPath.section == 0 && indexPath.row == 0)
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
        }
        else if(![Utility isStringEmpty:receipt.remark])
        {
            if(indexPath.section == 1 && indexPath.row == 0)
            {
                [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbReceiptDisputeRating)
    {
        [Utility updateSharedObject:items];
        NSMutableArray *ratingList = items[2];
        
        if([ratingList count] > 0)
        {
            _rating = ratingList[0];
        }
        
        
        [tbvData reloadData];
        [tbvRating reloadData];
    }
    else if(homeModel.propCurrentDB == dbReceipt)//check ปุ่ม
    {
        [self removeOverlayViews];
        NSMutableArray *receiptList = items[0];
        Receipt *downloadReceipt = receiptList[0];
        if(downloadReceipt.status == 5 || downloadReceipt.status == 6)
        {
            receipt.status = downloadReceipt.status;
            receipt.statusRoute = downloadReceipt.statusRoute;
            [tbvData reloadData];
            NSString *message = [Language getText:@"ร้านค้ากำลังปรุงอาหารให้คุณอยู่ค่ะ โปรดรอสักครู่นะคะ"];
            NSString *message2 = [Language getText:@"อาหารได้ส่งถึงคุณแล้วค่ะ"];
            NSString *strMessage = downloadReceipt.status == 5?message:message2;
            [self showAlert:@"" message:strMessage];
        }
        else
        {
            _fromType = 1;
            [self performSegueWithIdentifier:@"segConfirmDispute" sender:self];
        }
    }
}

-(void)orderItAgain:(id)sender
{
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
    [OrderTaking setCurrentOrderTakingList:orderTakingList];
    
    
    //belong to buffet
    if(receipt.buffetReceiptID)
    {
        Receipt *buffetReceipt = [Receipt getReceipt:receipt.buffetReceiptID];
        if(buffetReceipt)
        {
            NSInteger timeToOrder = buffetReceipt.timeToOrder;
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
            NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
            if(timeToCountDown <= 0)
            {
                [self showAlert:@"" message:[Language getText:@"ขอโทษค่ะ หมดเวลาสั่งบุฟเฟ่ต์แล้วค่ะ"]];
                return;
            }
        }
        else
        {
            [self showAlert:@"" message:[Language getText:@"ขอโทษค่ะ หมดเวลาสั่งบุฟเฟ่ต์แล้วค่ะ"]];
            return;
        }
    }
    
    _receiptBranch = [Branch getBranch:receipt.branchID];
    [self performSegueWithIdentifier:@"segCreditCardAndOrderSummary" sender:self];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReceiptSummary" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segCreditCardAndOrderSummary"])
    {
        CreditCardAndOrderSummaryViewController *vc = segue.destinationViewController;
        vc.branch = _receiptBranch;
        vc.customerTable = nil;
        vc.fromOrderDetailMenu = 1;
        Receipt *buffetReceipt = [Receipt getReceipt:receipt.buffetReceiptID];
        vc.buffetReceipt = buffetReceipt;
    }
    else if([[segue identifier] isEqualToString:@"segConfirmDispute"])
    {
        ConfirmDisputeViewController *vc = segue.destinationViewController;
        vc.fromType = _fromType;
        vc.receipt = receipt;
    }
    else if([[segue identifier] isEqualToString:@"segCommentRating"])
    {
        CommentRatingViewController *vc = segue.destinationViewController;
        vc.rating = _rating;
    }
    else if([[segue identifier] isEqualToString:@"segCommentRatingView"])
    {
        CommentRatingViewController *vc = segue.destinationViewController;
        vc.rating = _rating;
        vc.viewComment = 1;
    }
}

-(void)disputeOrder:(id)sender
{
    _fromType = 2;
    [self performSegueWithIdentifier:@"segConfirmDispute" sender:self];
}

-(void)cancelOrder:(id)sender
{
    //check current process in case user stay long time in this screen while the process going to another status already
    //if receipt.status == 5 then show alert msg ร้านค้ากำลังปรุงอาหารให้คุณอยู่ค่ะ โปรดรอสักครู่นะคะ
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbReceipt withData:receipt];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    NSLog(@"UIModalPresentationNone");
    return UIModalPresentationNone;
}

-(void)confirmNegotiate:(id)sender
{
    [self loadingOverlayView];
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.status = 13;
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbReceipt withData:updateReceipt actionScreen:@"update receipt status"];
}

-(void)negotiate:(id)sender
{
    [self loadingOverlayView];
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.status = 11;
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbReceipt withData:updateReceipt actionScreen:@"update receipt status"];
}

- (void)itemsUpdatedWithManager:(NSObject *)objHomeModel items:(NSArray *)items;
{
    [self removeOverlayViews];
    [Utility updateSharedObject:items];
    [tbvData reloadData];
}

-(void)btnRate1
{
    Rating *rating = [Rating getRatingWithReceiptID:receipt.receiptID];
    if(!rating)
    {
        _rating.score = 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CustomTableViewCellRating *cell = [tbvRating cellForRowAtIndexPath:indexPath];
        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
    }
}

-(void)btnRate2
{
    Rating *rating = [Rating getRatingWithReceiptID:receipt.receiptID];
    if(!rating)
    {
        _rating.score = 2;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CustomTableViewCellRating *cell = [tbvRating cellForRowAtIndexPath:indexPath];
        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
    }
}

-(void)btnRate3
{
    Rating *rating = [Rating getRatingWithReceiptID:receipt.receiptID];
    if(!rating)
    {
        _rating.score = 3;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CustomTableViewCellRating *cell = [tbvRating cellForRowAtIndexPath:indexPath];
        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
    }
}

-(void)btnRate4
{
    Rating *rating = [Rating getRatingWithReceiptID:receipt.receiptID];
    if(!rating)
    {
        _rating.score = 4;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CustomTableViewCellRating *cell = [tbvRating cellForRowAtIndexPath:indexPath];
        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRatingGray.png"] forState:UIControlStateNormal];
    }
}

-(void)btnRate5
{
    Rating *rating = [Rating getRatingWithReceiptID:receipt.receiptID];
    if(!rating)
    {
        _rating.score = 5;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CustomTableViewCellRating *cell = [tbvRating cellForRowAtIndexPath:indexPath];
        [cell.btnRate1 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate2 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate3 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate4 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
        [cell.btnRate5 setBackgroundImage:[UIImage imageNamed:@"starRating.png"] forState:UIControlStateNormal];
    }
}

-(void)submitRating
{
    if(!_rating.score)
    {
        NSString *message = [Setting getValue:@"121m" example:@"กรุณาให้คะแนนก่อนกด Submit"];
        [self showAlert:@"" message:message];
        return;
    }
    _rating.modifiedUser = [Utility modifiedUser];
    _rating.modifiedDate = [Utility currentDateTime];
    [self.homeModel insertItems:dbRating withData:_rating actionScreen:@"insert rating"];
}

-(void)addComment
{
    [self performSegueWithIdentifier:@"segCommentRating" sender:self];
}

-(void)viewComment
{
    [self performSegueWithIdentifier:@"segCommentRatingView" sender:self];
}

-(void)itemsInsertedWithReturnData:(NSArray *)items
{
    NSMutableArray *ratingList = items[0];
    Rating *rating = ratingList[0];
    _rating = rating;
    
    
    [Rating addObject:rating];
    [tbvRating reloadData];
    NSString *title = [Setting getValue:@"100t" example:@"Thank you"];
    NSString *message = [Setting getValue:@"100m" example:@"We hope you have enjoyed our service. For comments, compliments or enquiries, please write to us below"];
    [self showAlert:title message:message];
}

-(void)reloadTableView
{
    [tbvData reloadData];
    [tbvRating reloadData];
}

- (IBAction)refresh:(id)sender
{
    [self viewDidAppear:NO];
}
@end
